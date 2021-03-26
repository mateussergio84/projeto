import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/lista.dart';
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

  void _editar(Produto produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        TextEditingController txtQuantidade = TextEditingController(text: produto.quantidade.toString());
        TextEditingController txtMinimo = TextEditingController(text: produto.minimo.toString());

        Future<void> update() async {
          String phpurl = "http://192.168.1.109/PHP/update.php";


          var res = await http.post(phpurl, body: {
            "id": produto.id.toString(),
            "quantidade": txtQuantidade.text,
            "minimo": txtMinimo.text,
          });
        }


        Future edit() async {
          return await http.post(
            "http://192.168.1.109/PHP/updateMin.php",
            body: {
              "id": produto.id.toString(),
              "quantidade": txtQuantidade.text,
              "minimo": txtMinimo.text,
            },
          );
        }
        return AlertDialog(
          title: Text(produto.nome,
          ),
          content: SingleChildScrollView(
        child: Container(
            child: (
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: txtQuantidade,
                      decoration: InputDecoration(
                        labelText:"Quantidade:",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    )
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: txtMinimo,
                      decoration: InputDecoration(
                        labelText:"Minimo:",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    )
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Cancelar')),
            FlatButton(onPressed: (){
              edit();
              _getProdutos();
              Navigator.of(context).pop();

            }, child: Text('Salvar')),
                    ],
                  ),
                ),
                  ]
                 )
                )
            ),
          ),
        );
      },
    );
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
                  subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Desejavel: "+produtos[index].minimo.toString(),
                    textAlign: TextAlign.center,
                  ),
                  onTap: (){
                    _editar(produtos[index]);
                  },
                )
            );
          },
        ));
  }
}