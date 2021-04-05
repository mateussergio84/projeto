import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/produto.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'api.dart';

class busca extends StatefulWidget {
 @override
  _buscaState createState() => _buscaState();
}

String barcodeScanRes;
String _scanBarcode;

class _buscaState extends State<busca> {
  var produtos = new List<Produto>();

  TextEditingController txtCod = TextEditingController();


    Future<void> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);

      print(barcodeScanRes);
      var url="http://192.168.1.109/PHP/teste2.php/";
    var res = await http.post(url, body: {
      'cod': barcodeScanRes,},
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<Produto> fetchPost() async {
    final response = await http.get("http://192.168.1.109:80/PHP/teste2.php/?cod="+txtCod.toString());

    if (response.statusCode == 200) {
      // se o servidor retornar um response OK, vamos fazer o parse no JSON
     return Produto.fromJson(json.decode(response.body));
      //Iterable list = json.decode(response.body);
      //produtos = list.map((model) => Produto.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> delete() async {
    var url="http://192.168.1.109/PHP/teste2.php/";
    var res = await http.post(url, body: {
      'cod': txtCod.text,},
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
    //fetchPost();
   // delete();
  }
  dispose() {
    super.dispose();
  }



  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pesquisa"),),
           body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {         
                },
                controller: txtCod,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: IconButton(icon: Icon(Icons.search_sharp),
                    onPressed: (){
                      delete();
                    },
                    ),
                    suffixIcon: IconButton(
                          icon:Image.asset(
                            'assets/icon.png',
                          ),
                    onPressed: (){
                      scanBarcodeNormal();
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
                  return Card(
                      child:ListTile(title: Text(produtos[index].nome,
                        textAlign: TextAlign.center,
                      ),
                        //subtitle: Text("Quantidade: " +produtos[index].quantidade.toString() +"  Desejavel: "+produtos[index].minimo.toString(),
                          //textAlign: TextAlign.center,
                        //),
                        onTap: (){
                        },
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
      