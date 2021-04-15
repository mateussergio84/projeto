import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/menu.dart';
import 'package:http/http.dart' as http;

import 'cadUsuario.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  String errormsg;
  bool error, showprogress;
  String email, senha;

  var _email = TextEditingController();
  var _senha = TextEditingController();

  startLogin() async {
    String apiurl = "http://192.168.1.109/PHP/login.php";
    print(email);

    var response = await http.post(apiurl, body: {
      'email': email,
      'senha': senha
    });

    if(response.statusCode == 200){
      var jsondata = json.decode(response.body);
      if(jsondata["error"]){
        setState(() {
          showprogress = false;
          error = true;
          errormsg = jsondata["message"];
        });
      }else{
        if(jsondata["success"]){
          setState(() {
            error = false;
            showprogress = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>menu() ),
          );
          _email.text = "";
          _senha.text = "";
          //mudar tela

        }else{
          showprogress = false;
          error = true;
          errormsg = "Erro";
        }
      }
    }else{
      setState(() {
        showprogress = false;
        error = true;
        errormsg = "Erro na conexão";
      });
    }
  }

  @override
  void initState() {
    email = "";
    senha = "";
    errormsg = "";
    error = false;
    showprogress = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
    ));

    return Scaffold(
      body: SingleChildScrollView(
          child:Container(
            constraints: BoxConstraints(
                minHeight:MediaQuery.of(context).size.height
            ),
            width:MediaQuery.of(context).size.width,
            decoration:BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [ Colors.lightBlue,Colors.lightBlueAccent,
                  Colors.blue[800], Colors.blue[700],
                ],
              ),
            ),

            padding: EdgeInsets.all(20),
            child:Column(children:<Widget>[

              /*Container(
                        margin: EdgeInsets.only(top:80),
                        child: Text("Login", style: TextStyle(
                            color:Colors.white,fontSize: 40, fontWeight: FontWeight.bold
                        ),), //title text
                     ),
*/
              Container(
                margin: EdgeInsets.only(top:130),
                padding: EdgeInsets.all(10),
                child:error? errmsg(errormsg):Container(),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                margin: EdgeInsets.only(top:10),
                child: TextField(
                  controller: _email,
                  style:TextStyle(color:Colors.white, fontSize:20),
                  decoration: myInputDecoration(
                    label: "Email",
                    icon: Icons.person,
                  ),
                  onChanged: (value){
                    email = value;
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _senha,
                  style: TextStyle(color:Colors.white, fontSize:20),
                  obscureText: true,
                  decoration: myInputDecoration(
                    label: "Senha",
                    icon: Icons.lock,
                  ),
                  onChanged: (value){
                    senha = value;
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top:20),
                child: SizedBox(
                  height: 60, width: double.infinity,
                  child:RaisedButton(
                    onPressed: (){
                      setState(() {
                        showprogress = true;
                      });
                      startLogin();

                    },
                    child: showprogress?
                    SizedBox(
                      height:30, width:30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ):Text("LOGIN", style: TextStyle(fontSize: 20),),
                    colorBrightness: Brightness.dark,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(30)
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top:20),
                alignment: Alignment.topRight,
                child: InkResponse(
                    onTap:(){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>cadUsuario() ),
                );
                    },
                    child:Text("sign up",
                      style: TextStyle(color:Colors.white, fontSize:20),
                    )
                ),
              )
            ]),
          )
      ),
    );
  }

  InputDecoration myInputDecoration({String label, IconData icon}){
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color:Colors.white, fontSize:20),
      prefixIcon: Padding(
          padding: EdgeInsets.only(left:20, right:10),
          child:Icon(icon, color: Colors.white,)
      ),

      contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color:Colors.white, width: 1)
      ),

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color:Colors.white, width: 1)
      ),
    );
  }

  Widget errmsg(String text){
    return Container(
      padding: EdgeInsets.all(15.00),
      margin: EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.indigo,
          border: Border.all(color:Colors.indigo[300], width:2)
      ),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right:6.00),
          child: Icon(Icons.info, color: Colors.white),
        ),

        Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ]),
    );
  }

}
