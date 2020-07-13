import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:graphic/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Configuracoes {
  static final List<String> daysOfTheWeek = const [
    "Domingo",
    "Segunda",
    "Terça",
    "Quarta",
    "Quinta",
    "Sexta",
    "Sabado",
  ];

  static final List<String> abvDaysOfTheWeek = const ["D", "S", "T", "Q", "Q", "S", "S"];

  static String formatterDate(String data) {
    initializeDateFormatting("pt_BR");
    DateTime dataConvertida = DateTime.parse(data);
    //var formatter = DateFormat("d/M/y");
    var formatter = DateFormat.yMd("pt_BR");
    String dataFomatada = formatter.format(dataConvertida);
    return dataFomatada;
  }

  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> itensDropEstados = [];

    //ESTADOS
    itensDropEstados.add(
      DropdownMenuItem(
        child: Text(
          "Região",
          style: TextStyle(
            color: defaultTheme.accentColor,
          ),
        ),
        value: null,
      ),
    );
    for (var estado in Estados.listaEstados) {
      itensDropEstados.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }

    return itensDropEstados;
  }
}
