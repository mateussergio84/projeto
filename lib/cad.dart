import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'pesquisa.dart';

class cad extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _cadState();
  }
}

class _cadState extends State<cad>{
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtCod = TextEditingController();
  TextEditingController txtQuantidade = TextEditingController();
  TextEditingController txtPreco = TextEditingController();
  TextEditingController txtMinimo = TextEditingController();
  TextEditingController txtMaximo = TextEditingController();
  TextEditingController txtValidade = TextEditingController();

  void fetchProduto() async {
  final response =
      await http.get('https://barcode.monster/api/'+barcodeScanRes);

  if (response.statusCode == 200) {
    var produtos = pesquisa.fromJson(jsonDecode(response.body));
    String descricao = produtos.description.toString();
    if(descricao.length >=23){
      descricao = descricao.substring(0, descricao.length - 23);
    }
    txtNome = TextEditingController(text: descricao);
    print(descricao);
  } else {
    throw Exception('Erro');
  }
}

  bool error, sending, success;
  String msg;

  String phpurl = "http://192.168.1.109/PHP/cad.php";



  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }
  String barcodeScanRes;
  String _scanBarcode;


  Future<void> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
        txtCod = TextEditingController(text: barcodeScanRes);
        print(barcodeScanRes);
        final response = await http.get('https://barcode.monster/api/'+barcodeScanRes);
          if (response.statusCode == 200) {
            var produtos = pesquisa.fromJson(jsonDecode(response.body));
            String descricao = produtos.description.toString();
            if(descricao.length >=23){
              descricao = descricao.substring(0, descricao.length - 23);
            }
            txtNome = TextEditingController(text: descricao);
            print(descricao);
          } else {
            throw Exception('Erro');
          }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> sendData() async {

    var res = await http.post(phpurl, body: {
      "nome": txtNome.text,
      "cod": txtCod.text,
      "quantidade": txtQuantidade.text,
      "preco": txtPreco.text,
      "minimo": txtMinimo.text,
      "maximo": txtMaximo.text,
      "vencimento": txtValidade.text,
    });

    if (res.statusCode == 200) {
      print(res.body);
      var data = json.decode(res.body);
      if(data["error"]){
        setState(() {
          sending = false;
          error = true;
          msg = data["message"];
        });
      }else{
        Scaffold
            .of(context)
            .showSnackBar(
          SnackBar(
            content:
            Text("cadastrado com sucesso"),
          ),
        );
        txtNome.text = "";
        txtCod.text = "";
        txtQuantidade.text = "";
        txtPreco.text = "";
        txtMinimo.text = "";
        txtMaximo.text = "";
        txtValidade.text = "";
        setState(() {
          sending = false;
          success = true;
        });
      }

    }else{
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Estoque - Cadastro"),
          backgroundColor:Colors.blue[400],
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
          child:Container(
              padding: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(18),
                    child: TextField(
                      controller: txtCod,
                      decoration: InputDecoration(
                        labelText:"Codigo:",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon:Image.asset(
                            'assets/icon.png',
                          ),
                          onPressed: (){
                            scanBarcodeNormal();
                          }
                        )
                      ),
                      keyboardType: TextInputType.number,
                    ),
                ),

                Container(
                    padding: const EdgeInsets.all(18),
                    child: TextField(
                      controller: txtNome,
                      decoration: InputDecoration(
                        labelText:"Nome:",
                        border: OutlineInputBorder(),
                      ),
                    )
                ),

                Container(
                    padding: const EdgeInsets.all(18),
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
                    padding: const EdgeInsets.all(18),
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
                    padding: const EdgeInsets.all(18),
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
                    padding: const EdgeInsets.all(18),
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
                    padding: const EdgeInsets.all(18),
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
                    margin: EdgeInsets.only(top:20),
                    child:SizedBox(
                        width: double.infinity,
                        child:RaisedButton(
                          onPressed:(){
                            setState(() {
                              sending = true;
                            });
                            sendData();
                          },
                          child: Text(
                            sending?"Salvando...":"Salvar",
                          ),
                          color: Colors.blueAccent,
                          colorBrightness: Brightness.dark,
                        )
                    )
                )
              ],)
          )
      ),
    );
  }
}