
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/produto.dart';
import 'api.dart';
import 'package:http/http.dart' as http;



class lista extends StatefulWidget {
  @override
  createState() => _listaState();
}
class _listaState extends State {

  var produtos = new List<Produto>();


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
                    child: Text('Codigo: '+produto.codProd.toString())
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
              Navigator.of(context).pop();
            }, child: Text('Volta'))
          ],
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
              // Fornecemos uma função que diz ao app
              // o que fazer depois que o item for arrastado
              onDismissed: (direction) {
                setState(() {
                  var url="http://192.168.1.109/PHP/t1.php/";
                     http.post(url, body: {
                        'id': produtos[index].id.toString(),});
                           _getProdutos();
                         });
                // Exibe o snackbar
                Scaffold
                    .of(context)
                    .showSnackBar(
                      SnackBar(
                        content: 
                        Text(
                          produtos[index].nome.toString()+"foi removido"),
                        ),
                     );
              },
              // Exibe uma cor vermelha de fundo 
              // quando o item for arrastado
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
              subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Preço: "+produtos[index].preco.toString(),
              textAlign: TextAlign.center,
              ),
                  onTap: (){
                  _detalhes(produtos[index]);
                  },

              )
            ));
        },
      ));
  }
  }
  

  