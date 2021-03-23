import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://192.168.1.109:80/PHP/";
class API {
  static Future getProdutos() {
     var url = baseUrl + "/selectProdutos.php";
     return http.get(url);  
  }
}


class API3 {
  static Future getFalta() {
    var url = baseUrl + "/selectFalta.php";
    return http.get(url);
  }
}

class APIT {
  static Future getTotal() {
    var url = baseUrl + "/total.php";
    return http.get(url);
  }
}


class API2 {
  static Future getVencidos() {
    var url = baseUrl + "/selectVencidos.php";
    return http.get(url);
  }}

class API4 {
  static Future geMaximo() {
    var url = baseUrl + "/select_maximo.php";
    return http.get(url);
  }
}
