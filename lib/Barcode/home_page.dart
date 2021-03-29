import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page_controller.dart';

class HomePage extends StatelessWidget {
  HomePage() {
    Get.put(HomePageController());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estoque - Delete'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //remover return Text
            GetBuilder<HomePageController>(
              builder: (controller) {
                return Text(
                  controller.valorCodigoBarras,
                  style: Get.theme.textTheme.headline5,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextButton.icon(
              icon: Image.asset(
                'assets/icon.png',
                width: 50,
              ),
              label: Text('Ler Código de Barras', style: Get.theme.textTheme.headline6),
              onPressed: () => Get.find<HomePageController>().escanearCodigoBarras(),
            ),

          ],
        ),
      ),
    );
  }
}
