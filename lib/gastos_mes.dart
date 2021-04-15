import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'Gasto.dart';
import 'api.dart';


class gastos_mes extends StatefulWidget {
  @override
  createState() => _gastos_mesState();
}
class _gastos_mesState extends State {
var produtos = new List<Produto>();
  var gasto = List<Gasto>();
  num total = 0;


 _getProdutos() {
    APIM.getTotal().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        produtos = list.map((model) => Produto.fromJson(model)).toList();
      });
    });
  }

  _getGastos() {
    APIGm.getGastos().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        gasto = list.map((model) => Gasto.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getProdutos();
    _getGastos();
  }

  dispose() {
    super.dispose();
  }


  @override
  build(context) {
    return Column(
      children:  [
        Expanded(child:
        ListView.builder(
        itemCount: produtos.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(title: Text(produtos[index].nome,
                  textAlign: TextAlign.center,
                ),
                  subtitle: Text(
                    "Preço: R\$" + produtos[index].preco.toString() +
                        "  Total: R\$" + produtos[index].total.toString(),
                    textAlign: TextAlign.center,
                  ),
                )
            );
          },
        ),
        flex: 9,
        ),


        Expanded(child:
        ListView.builder(
          itemCount: gasto.length,
          itemBuilder: (context, index) {
            return 
            Text("Gastos R\$"+gasto[index].total.toString()+
                  " em "+gasto[index].itens.toString()+" itens",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  textAlign: TextAlign.center,
                );
          },
        ),),
      ],
    );
  }
}





  

