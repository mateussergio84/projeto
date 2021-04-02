import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/delete.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:http/http.dart' as http;

class busca extends StatefulWidget {
 //final String cod;
 //const busca({Key key, this.cod}): super(key: key);
  String cod;
  busca(String cod);

 @override
  _buscaState createState() => _buscaState();
// widget.cod
}

class _buscaState extends State<busca> {
  var produtos = new List<Produto>();
  //print(widget.cod)

  Future<Produto> fetchPost() async {
    var url="http://192.168.1.109/PHP/select.php/";
    var res = await http.post(url, body: {
      "cod": widget.cod,
    });

   // final response = await http.get("http://192.168.1.109:80/PHP/teste2.php/?cod="+widget.cod);

    if (res.statusCode == 200) {
      // se o servidor retornar um response OK, vamos fazer o parse no JSON
     return Produto.fromJson(json.decode(res.body));
      //Iterable list = json.decode(response.body);
      //produtos = list.map((model) => Produto.fromJson(model)).toList();
    } else {
      // se a responsta não for OK , lançamos um erro
      throw Exception('Failed to load post');
    }
  }

  _getProdutos() async {
    //print('widget'+widget.cod);
   // String C = "12345670";
    var url = "http://192.168.1.109:80/PHP/teste2.php/?cod="+widget.cod;
    final response = await http.get(url);
    {
      setState(() {
        Iterable list = json.decode(response.body);
        produtos = list.map((model) => Produto.fromJson(model)).toList();
      });
    };
  }

  initState() {
    super.initState();
    fetchPost();
    //_getProdutos();
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
                  subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Preço: "+produtos[index].preco.toString(),
                    textAlign: TextAlign.center,
                  ),
                  onTap: (){
                  },
                )
            );
          },
        ));
  }
}

