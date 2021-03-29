import 'package:flutter/material.dart';
import 'package:flutter_application_1/Barcode/barcode.dart';
import 'package:flutter_application_1/cadUsuario.dart';
import 'package:flutter_application_1/lista.dart';
import 'package:flutter_application_1/login.dart';

import 'cad.dart';
import 'gastos.dart';
import 'list.dart';
import 'listas_gastos.dart';
import 'Barcode/home_page.dart';
import 'Barcode/barcode.dart';

class menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    lista(),
    cad(),
    list(),
    barcode(),
    listas_gastos(),

  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            //backgroundColor: Colors.blue,
            icon: Icon(
              Icons.home_filled,
            ),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            title: Text(
              'Add',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
            ),
            title: Text(
              'Listas',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.delete,
            ),
            title: Text(
              'Remover',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money_rounded,
            ),
            title: Text(
              'Gastos',
            ),
          ),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}