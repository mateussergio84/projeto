import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'api.dart';
import 'package:http/http.dart' as http;



class falta extends StatefulWidget {
  @override
  createState() => _faltaState();
}
class _faltaState extends State {

  var produtos = new List<Produto>();


  _getProdutos() {
    API3.getFalta().then((response) {
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
        ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            return Card(
                child:ListTile(title: Text(produtos[index].nome,
                  textAlign: TextAlign.center,
                ),
                  subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Desejavel: "+produtos[index].minimo.toString(),
                    textAlign: TextAlign.center,
                  ),
                )
            );
          },
        ));
  }
}