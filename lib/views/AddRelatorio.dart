import 'package:flutter/material.dart';
import 'package:graphic/main.dart';
import 'package:graphic/views/graphic/formGraphic/FormGraphicBar.dart';
import 'package:graphic/views/graphic/formGraphic/FormGraphicBarHorizontal.dart';
import 'package:graphic/views/graphic/formGraphic/FormGraphicLine.dart';
import 'package:graphic/views/graphic/formGraphic/FormGraphicLineBar.dart';
import 'package:graphic/views/graphic/formGraphic/FormGraphicPie.dart';
import 'package:graphic/views/graphic/formGraphic/FormGraphicPieLegend.dart';

class AddRelatorio extends StatefulWidget {
  final Map<String, String> opGraphic;
  AddRelatorio(this.opGraphic);
  @override
  _AddRelatorioState createState() => _AddRelatorioState();
}

class _AddRelatorioState extends State<AddRelatorio> {
  Map<String, String> _graphic;

  _getForm() {
    if (_graphic["type"] == "bar") {
      return FormGraphicBar(_graphic["type"]);
    } else if (_graphic["type"] == "barHorizontal") {
      return FormGraphicBarHorizontal(_graphic["type"]);
    
    } else if (_graphic["type"] == "lineBar") {
      return FormgraphicLineBar(_graphic["type"]);
   
    } else if (_graphic["type"] == "line") {
      return FormGraphicLine(_graphic["type"]);
  
    } else if (_graphic["type"] == "pie") {
      return FormGraphicPie(_graphic["type"]);
    } else if (_graphic["type"] == "pieLegend") {
      return FormGraphicPieLegend(_graphic["type"]);
    }
  }

  @override
  void initState() {
    super.initState();
    _graphic = widget.opGraphic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: defaultTheme.primaryColor,
        title: Text(_graphic["title"]),
      ),
      body: _getForm(),
    );
  }
}
