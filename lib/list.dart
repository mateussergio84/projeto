import 'package:flutter/material.dart';
import 'package:flutter_application_1/compras.dart';
import 'package:flutter_application_1/lista.dart';
import 'package:flutter_application_1/vencidos.dart';

import 'falta.dart';
import 'maximo.dart';



class list extends StatefulWidget {
  @override
  _listState createState() => _listState();
}

class _listState extends State<list>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget getTabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(text: "Vencidos", icon: Icon(Icons.list)),
      Tab(text: "Falta", icon: Icon(Icons.list_alt)),
      Tab(text: "Excede", icon: Icon(Icons.list_alt_outlined)),
      Tab(text: "Compras", icon: Icon(Icons.list_alt)),
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(controller: tabController, children: <Widget>[
      new vencidos(),
      new falta(),
      new maximo(),
      new compras(),
    ]);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: getTabBar(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: getTabBarPages());
  }
}