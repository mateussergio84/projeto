import 'package:flutter/material.dart';
import 'package:flutter_application_1/gastos_mes.dart';
import 'package:flutter_application_1/gastos_semana.dart';
import 'gastos.dart';



class listas_gastos extends StatefulWidget {
  @override
  _listas_gastosState createState() => _listas_gastosState();
}

class _listas_gastosState extends State<listas_gastos>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget getTabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(text: "Total", icon: Icon(Icons.list)),
      Tab(text: "Mês", icon: Icon(Icons.list_alt)),
      Tab(text: "Semana", icon: Icon(Icons.list_alt_outlined)),
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(controller: tabController, children: <Widget>[
      new gastos(),
      new gastos_mes(),
      new gastos_semana(),
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