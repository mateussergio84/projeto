import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';


class barcode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
      ],
    );
  }
}
