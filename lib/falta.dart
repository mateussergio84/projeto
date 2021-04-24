import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;




class falta extends StatefulWidget {
  @override
  createState() => _faltaState();
}
class _faltaState extends State {

  var produtos = new List<Produto>();

  Future<void> select() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/Select.php/?op=3&id="+ID;
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
                  textAlign: TextAlign.center
                  ,
                ),
                  //mudar quantidade para quant
                  subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Desejavel: "+produtos[index].minimo.toString(),
                    textAlign: TextAlign.center,
                  ),
                )
            );
          },
        ));
  }
}