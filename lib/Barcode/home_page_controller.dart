import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class HomePageController extends GetxController { 
  var valorCodigoBarras = '';



  void delete(){
          var url="http://192.168.1.109/PHP/codigo.php/";
          http.post(url, body: {
            'cod': valorCodigoBarras.toString(),});
        }


  Future<void> escanearCodigoBarras() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                    '#ff6666', 
                                                    'Cancelar',
                                                    true,
                                                    ScanMode.BARCODE);

    if(barcodeScanRes == '-1') {
      //Get.snackbar('Cancelado', 'Leitura Cancelada');
    }else{
      valorCodigoBarras = barcodeScanRes;
      delete();

      /*SnackBar(
          content: Text('Produto excuido, codigo '+valorCodigoBarras.toString()));*/
      //update();
      //passar variavel para uma tela de lista
    }

  }

}