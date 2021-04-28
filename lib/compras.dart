import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class compras extends StatefulWidget {
  @override
  createState() => _comprasState();
}
class _comprasState extends State {

  var produtos = new List<Produto>();

  List data;

  var index;


  Future<void> select() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/Select.php/?op=5&id="+ID;
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


  @override
  build(context) {
    return Scaffold(
      body:
            ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        var url="http://192.168.1.109/PHP/deleteCompras.php";
                        http.post(url, body: {
                          'cod': produtos[index].cod.toString(),});
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
                        )
                    ));
              },
            ),
        );
  }
}