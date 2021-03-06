import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Gasto.dart';
import 'package:http/http.dart' as http;


class gastos_semana extends StatefulWidget {
  @override
  createState() => _gastos_semanaState();
}
class _gastos_semanaState extends State {
  var produtos = new List<Produto>();
  var gasto = List<Gasto>();


  Future<void> select() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/Gastos.php/?op=2&id="+ID;
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


  Future<void> select2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/Gastos.php/?op=5&id="+ID;
    var res = await http.post(url);
    if (res.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(res.body);
        gasto = list.map((model) => Gasto.fromJson(model)).toList();
      });
    }else {
      throw Exception('Error');
    }
  }

  initState() {
    super.initState();
    select();
    select2();
  }


  @override
  build(context) {
    return Column(
      children:  [
        Expanded(child:
        //ListView.builder(
        gasto.isEmpty ? Center(child: Text("Empty")) : ListView.builder(
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
        //ListView.builder(
        gasto.isEmpty? (Text("Empty")) : ListView.builder(
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