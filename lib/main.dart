import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';

import 'gastos.dart';
import 'gastos_mes.dart';
import 'listas_gastos.dart';
import 'listas_gastos.dart';
import 'menu.dart';
import 'Barcode/home_page.dart';

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
      ],
    );
  }
}
*/

void main() {
  runApp(MaterialApp(
    home: menu(),
  ));
}

