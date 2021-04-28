import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class vencidos extends StatefulWidget {
  @override
  createState() => _vencidosState();
}
class _vencidosState extends State {

  var produtos = new List<Produto>();


  Future<void> select() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/Select.php/?op=2&id="+ID;
    var res = await http.post(url);
    if (res.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(res.body);
        produtos = list.map((model) => Produto.fromJson(model)).toList();
      });
    }else {
      throw Exception('Error');
    }
  }

  initState() {
    super.initState();
    select();
  }

  bool error, sending, success;
  String msg;

  String phpurl = "http://192.168.1.109/PHP/compras.php";

  Future<void> sendData(Produto produto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var res = await http.post(phpurl, body: {
      "nome": produto.nome,
      "cod": produto.cod.toString(),
      "id_usu": ID,
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
        print("add com sucesso");
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
  build(context) {
    return Scaffold(
      body:
      Column(
        children: <Widget>[
          Expanded(
            child:
            ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        var url="http://192.168.1.109/PHP/delete.php";
                        http.post(url, body: {
                          'id': produtos[index].id.toString(),});
                          select();
                      });
                      Scaffold
                          .of(context)
                          .showSnackBar(
                        SnackBar(
                          content:
                          Text(
                              produtos[index].nome.toString()+" foi excluido"),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment(-0.9, 0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    child: Card(
                        child:ListTile(title: Text(produtos[index].nome,
                          textAlign: TextAlign.center,
                        ),
                          subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  vencido em : "+produtos[index].vencimento.toString(),
                            textAlign: TextAlign.center,
                          ),
                           trailing:
                        Container(
                          width: 50,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.add_shopping_cart_rounded),
                                  color: Colors.indigo,
                                  onPressed: (){
                                    sendData(produtos[index]);
                                  }),
                            ]
                        )
                    )))
                    );
              },
            ),
          ),
        ],),
    );
  }
}