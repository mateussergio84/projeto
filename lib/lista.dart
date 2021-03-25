
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

import 'produto.dart';



class lista extends StatefulWidget {
  @override
  createState() => _listaState();
}
class _listaState extends State {

  var produtos = new List<Produto>();
  var i;

  _getProdutos() {
    API.getProdutos().then((response) {
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


  void _detalhes(Produto produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detalhes",
          ),

          content: Container(
            child: (
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Produto: '+produto.nome)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Codigo: '+produto.cod.toString())
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Quatidade: '+produto.quantidade.toString())
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Preço '+produto.preco.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('MInimo: '+produto.minimo.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Vencimento: '+produto.vencimento.toString()),
                  ),
                ],

            )
          ),
         ),
          actions: <Widget>[
            FlatButton(onPressed: (){
              _editar(i);
            }, child: Text('Editar')),
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Voltar')),
          ],
        );
      },
    );
  }



    void _editar(Produto produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        TextEditingController txtQuantidade = TextEditingController(text: produto.quantidade.toString());
        TextEditingController txtPreco = TextEditingController(text: produto.preco.toString());
        TextEditingController txtMinimo = TextEditingController(text: produto.minimo.toString());
        TextEditingController txtMaximo = TextEditingController(text: produto.maximo.toString());
        TextEditingController txtValidade = TextEditingController(text: produto.vencimento.toString());

        Future<void> update() async {
          String phpurl = "http://192.168.1.109/PHP/update.php";


          var res = await http.post(phpurl, body: {
            "id": produto.id.toString(),
            "quantidade": txtQuantidade.text,
            "preco": txtPreco.text,
            "minimo": txtMinimo.text,
            "maximo": txtMaximo.text,
            "vencimento": txtValidade.text,
          });
        }


        Future edit() async {
          return await http.post(
            "http://192.168.1.109/PHP/update.php",
            body: {
              "id": produto.id.toString(),
              "quantidade": txtQuantidade.text,
              "preco": txtPreco.text,
              "minimo": txtMinimo.text,
              "maximo": txtMaximo.text,
              "vencimento": txtValidade.text,
            },
          );
        }
        return AlertDialog(
          title: Text("Detalhes",
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
                          controller: txtPreco,
                          decoration: InputDecoration(
                            labelText:"Preço:",
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
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: txtMaximo,
                      decoration: InputDecoration(
                        labelText:"Maximo:",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    )
                ),

                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: txtValidade,
                      decoration: InputDecoration(
                        labelText:"Vencimento:",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
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
              update();
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
        appBar: AppBar(
          title: Text("Produtos"),
          centerTitle: true,
        ),
        body:
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
              subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Preço: R\$"+produtos[index].preco.toString(),
              textAlign: TextAlign.center,
              ),
                  onTap: (){
                  i = produtos[index];
                  _detalhes(produtos[index]);
                  _getProdutos();
                  },

              )
            ));
        },
      ),
    );
  }
}
  

  