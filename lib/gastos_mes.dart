import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'api.dart';


class gastos_mes extends StatefulWidget {
  @override
  createState() => _gastos_mesState();
}
class _gastos_mesState extends State {

  var produtos = new List<Produto>();
  num total = 0;


  _getProdutos() {
    APIT.getTotal().then((response) {
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
                child: ListTile(title: Text(produtos[index].nome,
                  textAlign: TextAlign.center,
                ),
                  subtitle: Text(
                    "Quantidade: " + produtos[index].quantidade.toString() +
                        "  Total: " + produtos[index].total.toString(),
                    textAlign: TextAlign.center,
                  ),
                )
            );
          },
        ));
  }
}