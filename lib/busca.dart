import 'package:flutter/cupertino.dart';

class busca extends StatefulWidget {
  final String cod;
  const busca({Key key, this.cod}): super(key: key);
  @override
  _buscaState createState() => _buscaState();
}

class _buscaState extends State<busca> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.cod);
  }
}
