import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/menu.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class busca extends StatefulWidget {
 @override
  _buscaState createState() => _buscaState();
}

String barcodeScanRes;
String _scanBarcode;

class _buscaState extends State<busca> {
  var produtos = new List<Produto>();

  TextEditingController txtCod = TextEditingController();


    Future<void> scanBarcode() async {
    try {
       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      var url="http://192.168.1.109/PHP/teste2.php/";
       SharedPreferences prefs = await SharedPreferences.getInstance();
       final ID = prefs.getString('ID') ?? '';
      var res = await http.post(url, body: {
        'cod': barcodeScanRes,
        'id': ID,
        },
      );
      if (res.statusCode == 200) {
        print(res.body);
        setState(() {
          Iterable list = json.decode(res.body);
          produtos = list.map((model) => Produto.fromJson(model)).toList();
        });
      }else {
        throw Exception('Error');
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<Produto> fetchPost() async {
    final response = await http.get("http://192.168.1.109:80/PHP/teste2.php/?cod="+txtCod.toString());

    if (response.statusCode == 200) {
     return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> buscaProduto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    String cod = txtCod.toString();
    var url="http://192.168.1.109/PHP/teste2.php/";
    var res = await http.post(url, body: {
      'cod': txtCod.text,
      'id' : ID,
      },
    );
    if (res.statusCode == 200) {
      print(res.body);
      setState(() {
        Iterable list = json.decode(res.body);
        produtos = list.map((model) => Produto.fromJson(model)).toList();
      });
    }else {
      throw Exception('Error');
    }
  }

  void _detalhes(Produto produto) {
    select();
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
                      child: Text('Maximo: '+produto.maximo.toString()),
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
              _editar(produto);
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
        TextEditingController txtNome = TextEditingController(text: produto.nome);
        TextEditingController txtQuantidade = TextEditingController(text: produto.quantidade.toString());
        TextEditingController txtPreco = TextEditingController(text: produto.preco.toString());
        TextEditingController txtMinimo = TextEditingController(text: produto.minimo.toString());
        TextEditingController txtMaximo = TextEditingController(text: produto.maximo.toString());
        TextEditingController txtValidade = TextEditingController(text: produto.vencimento.toString());

        Future<void> update() async {
          String phpurl = "http://192.168.1.109/PHP/update.php";
          var res = await http.post(phpurl, body: {
            "id": produto.id.toString(),
            "nome": txtNome.text,
            "quantidade": txtQuantidade.text,
            "preco": txtPreco.text,
            "minimo": txtMinimo.text,
            "maximo": txtMaximo.text,
            "vencimento": txtValidade.text,
          });
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
                                controller: txtNome,
                                decoration: InputDecoration(
                                  labelText:"Produto:",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                              )
                          ),
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
                                  select();
                                  //Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>menu() ),
                                  );

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



  Future<void> select() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/Select.php/?op=1&id="+ID;
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

  Future<void> buscaNome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ID = prefs.getString('ID') ?? '';
    var url="http://192.168.1.109/PHP/busca2.php/?prod="+txtCod.text+"&id="+ID;
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
      appBar: AppBar(title: Text("Busca"),
        automaticallyImplyLeading: false,
      ),
           body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {         
                },
                controller: txtCod,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: IconButton(icon: Icon(Icons.search_sharp),
                    onPressed: (){
                      if(txtCod != null){
                        //buscaProduto();
                        buscaNome();
                      }
                      //select();
                    },
                    ),
                    suffixIcon: IconButton(
                          icon:Image.asset(
                            'assets/icon.png',
                          ),
                    onPressed: (){
                      scanBarcode();
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        var url="http://192.168.1.109/PHP/delete.php/";
                        http.post(url, body: {
                          'id': produtos[index].id.toString(),});
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
                        //subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Desejavel: "+produtos[index].minimo.toString(),
                          //textAlign: TextAlign.center,
                        //),
                        onTap: (){
                        _detalhes(produtos[index]);
                        },
                      ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
      