import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/produto.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class vencidos extends StatefulWidget {
  @override
  createState() => _vencidosState();
}
class _vencidosState extends State {

  var produtos = new List<Produto>();

  List data;

  var index;


  _getProdutos() {
    API2.getVencidos().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        produtos = list.map((model) => Produto.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getProdutos();
  }
  dispose() {
    super.dispose();
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
                    var url="http://192.168.1.109/PHP/t1.php/";
                    http.post(url, body: {
                      'id': produtos[index].id.toString(),});
                    _getProdutos();
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
                    )
                ));
          },
        ),
    ),
    ],),
    );
  }
}