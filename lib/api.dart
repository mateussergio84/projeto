import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://192.168.1.109/PHP/";
class API {
  static Future getProdutos() {
     var url = baseUrl + "/selectProdutos.php";
     return http.get(url);  
  }
}