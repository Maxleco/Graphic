import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ignore: must_be_immutable
class BarGraphic extends StatefulWidget {
  List<String> namesGraphics;
  BarGraphic({this.namesGraphics});
  @override
  _BarGraphicState createState() => _BarGraphicState();
}

class _BarGraphicState extends State<BarGraphic> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  int touchedIndex;
  int totalGraphic;
  double maxValueGraphic;
  List<String> typesGraphic;
  List<String> titlesAbvGraphic = [];
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic> qtdGraphic = {};

  Future<Stream<QuerySnapshot>> _recuperandoDadosGraficos() {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("consultas").snapshots();
    // .document("bar")
    // .collection("graficos")
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _specTitles() {
    typesGraphic.forEach((element) {
      if (element == "bar") {
        titlesAbvGraphic.add("Bar");
      } else if (element == "line") {
        titlesAbvGraphic.add("Line");
      } else if (element == "lineBar") {
        titlesAbvGraphic.add("BarLine");
      } else if (element == "barHorizontal") {
        titlesAbvGraphic.add("BarH");
      } else if (element == "pie") {
        titlesAbvGraphic.add("Pie");
      } else if (element == "pieLegend") {
        titlesAbvGraphic.add("PieL");
      }
    });
  }

  _agruparGraficos() {
    qtdGraphic.clear();
    totalGraphic = 0;
    typesGraphic.forEach((nameGraphic) {
      int qtd = 0;
      // int index = typesGraphic.indexOf(nameGraphic);
      // String nameAbvGraphic = titlesAbvGraphic[index];
      data.forEach((element) {
        List<String> key = element.keys.toList();
        String graphic = key[0];
        if (graphic == nameGraphic) {
          qtd++;
        }
      });
      qtdGraphic.addAll({nameGraphic: qtd});
    });
    //Total e Valor Máximo
    double max = 0;
    qtdGraphic.forEach((key, value) {
      totalGraphic += value;
      double valor = (value as int).ceilToDouble();
      if (valor >= max) {
        max = valor;
      }
    });
    maxValueGraphic = max;
  }

  List<BarChartGroupData> showingBarGroups() {
    List<BarChartGroupData> listWidget = [];
    
    qtdGraphic.forEach((key, value) {
      int x;
      if (key == typesGraphic[0]) {
        x = 0;
      } else if (key == typesGraphic[1]) {
        x = 1;
      } else if (key == typesGraphic[2]) {
        x = 2;
      } else if (key == typesGraphic[3]) {
        x = 3;
      } else if (key == typesGraphic[4]) {
        x = 4;
      } else if (key == typesGraphic[5]) {
        x = 5;
      }
      double valor = (value as int).ceilToDouble();
      listWidget.add(
        BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(
              y: valor,
              color: Colors.lightBlueAccent,
              width: 10,
            ),
          ],
          showingTooltipIndicators: [0, 1],
        ),
      );
    });
    return listWidget;
  }

  @override
  void initState() {
    super.initState();
    _recuperandoDadosGraficos();
    typesGraphic = widget.namesGraphics;
    _specTitles();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Gráfico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Courier New",
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'de Barra',
                    style: TextStyle(
                      color: Color(0xff77839a),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Courier New",
                    ),
                  ),
                ],
              ),
              StreamBuilder<Object>(
                  stream: _controller.stream,
                  builder: (context, snapshot) {
                    Widget defaultWidget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      defaultWidget = Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              "Carregando Dados",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: "Courier New",
                              ),
                            ),
                            SizedBox(height: 5),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      if (snapshot.hasError) {
                        defaultWidget =
                            Center(child: Text("Errro ao carregar dados!"));
                      } else {
                        QuerySnapshot querySnapshot = snapshot.data;
                        if (querySnapshot.documents.length == 0) {
                          return Container(
                            child: Center(
                                child: Text(
                              "Nenhum dado salvo :(",
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          );
                        }
                        List<DocumentSnapshot> qtdDocuments =
                            querySnapshot.documents;
                        data.clear();
                        qtdDocuments.forEach((element) {
                          data.add(element.data);
                        });
                        _agruparGraficos();

                        defaultWidget = _getGraphic();
                      }
                    } else {
                      defaultWidget = Container();
                    }
                    return defaultWidget;
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getGraphic() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValueGraphic + 2,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: const Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 20,
            getTitles: _getTitlesData,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: const Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 32,
            reservedSize: 14,
            getTitles: _getTitlesLeft,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: showingBarGroups(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            fitInsideVertically: true,
            tooltipBottomMargin: 0,
            tooltipPadding: EdgeInsets.only(left: 16, right: 16, bottom: 26),
            getTooltipItem: (groupData, index1, rodData, index2) {
              String tip = rodData.y.toString();
              return BarTooltipItem(
                tip,
                TextStyle(
                  color: Colors.blue[200],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Courier New",
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getTitlesData(double value) {
    switch (value.toInt()) {
      case 0:
        return titlesAbvGraphic[0];
      case 1:
        return titlesAbvGraphic[1];
      case 2:
        return titlesAbvGraphic[2];
      case 3:
        return titlesAbvGraphic[3];
      case 4:
        return titlesAbvGraphic[4];
      case 5:
        return titlesAbvGraphic[5];
      case 6:
        return titlesAbvGraphic[6];
      default:
        return '';
    }
  }

  String _getTitlesLeft(double value) {
    String title;
    qtdGraphic.forEach((key, valor) {
      if (value.toInt() == valor) {
        title = '$valor';
      }
    });
    return title;
  }
}
