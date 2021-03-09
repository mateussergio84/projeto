import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class cadUsuario extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _cadUsuarioState();
  }
}

class _cadUsuarioState extends State<cadUsuario>{
    TextEditingController txtNome = TextEditingController();
    TextEditingController txtEmail = TextEditingController();
    TextEditingController txtSenha = TextEditingController();

  bool error, sending, success;
  String msg;

  String phpurl = "http://192.168.1.109/PHP/addUsuario.php";

  @override
  void initState() {
    error = false;        
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {

    var res = await http.post(phpurl, body: {
      "nome": txtNome.text,
      "email": txtEmail.text,
      "senha": txtSenha.text,
    }); 

    if (res.statusCode == 200) {
      print(res.body); 
      var data = json.decode(res.body);
      if(data["error"]){
        setState(() {
          sending = false;
          error = true;
          msg = data["message"];
        });
      }else{
        txtNome.text = "";
        txtEmail.text = "";
        txtSenha.text = "";

        setState(() {
          sending = false;
          success = true;
        });
      }

    }else{
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Estoque - Cadastro"),
          backgroundColor:Colors.blue[400]
      ), 

      body: SingleChildScrollView(
          child:Container(
              padding: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(18),
                    child: TextField(
                      controller: txtNome,
                      decoration: InputDecoration(
                        labelText:"Nome:",
                        border: OutlineInputBorder(),
                      ),
                    )
                ), 

                Container(
                  padding: const EdgeInsets.all(18),
                    child: TextField(
                      controller: txtEmail,
                      decoration: InputDecoration(
                        labelText:"Email:",
                        border: OutlineInputBorder(),
                      ),
                    )
                ), 

                Container(
                  padding: const EdgeInsets.all(18),
                    child: TextField(
                      controller: txtSenha,
                      decoration: InputDecoration(
                        labelText:"Senha:",
                        border: OutlineInputBorder(),
                      ),
                    )
                ), 

                Container(
                    margin: EdgeInsets.only(top:20),
                    child:SizedBox(
                        width: double.infinity,
                        child:RaisedButton(
                          onPressed:(){
                            setState(() {
                              sending = true;
                            });
                            sendData();
                          },
                          child: Text(
                            sending?"Sending...":"Cadastrar",
                          ),
                          color: Colors.blueAccent,
                          colorBrightness: Brightness.dark,
                        )
                    )
                )
              ],)
          )
      ),
    );
  }
}