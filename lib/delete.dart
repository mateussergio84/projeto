import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/busca.dart';
import 'package:flutter_application_1/cad.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class delete extends StatefulWidget {

  @override
  _deleteState createState() => _deleteState();
}

class _deleteState extends State<delete> {
  String _scanBarcode = 'Unknown';
  String barcodeScanRes;


  @override
  void initState() {
    super.initState();
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }


  Future<void> delete() async {
    var url="http://192.168.1.109/PHP/codigo.php/";
    var res = await http.post(url, body: {
      'cod': barcodeScanRes,},
    );
    if (res.statusCode == 200) {
      print(res.body);
      Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(
              content:
              Text("Produto excluido com sucesso"),
            ));
    }
    else{
      Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(
              content:
              Text("Produto não encontrado"),
            ));
    }
  }
  String msg;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      delete();
      print(barcodeScanRes);
      Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(
              content:
              Text("Codigo "+barcodeScanRes),
              duration: Duration(seconds: 2),
            ));
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(
              content:
              Text("Produto não encontrado"),
            ));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Estoque - delete')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Image.asset(
                            'assets/icon.png',
                            width: 90,
                          ),
                          label: Text('Scanear Código',
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                          onPressed: (){
                            scanBarcodeNormal();
                            String cod = barcodeScanRes;
                          },
                  //        onPressed: () => scanBarcodeNormal(),
                        ),
                      ]));
            })));
  }
}