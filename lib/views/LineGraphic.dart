import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraphic extends StatefulWidget {
  List<String> namesGraphics;
  LineGraphic({this.namesGraphics});
  @override
  _LineGraphicState createState() => _LineGraphicState();
}

class _LineGraphicState extends State<LineGraphic> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final _controller = StreamController<QuerySnapshot>.broadcast();
  bool showAvg = false;

  int touchedIndex;
  int totalGraphic;
  double maxValueGraphic;
  List<String> typesGraphic;
  List<String> titlesAbvGraphic = [];
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic> qtdGraphic = {};
  Map<String, List<double>> graphicCoordinates = {};

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
      data.forEach((element) {
        List<String> key = element.keys.toList();
        String graphic = key[0];
        if (graphic == nameGraphic) {
          qtd++;
        }
      });
      qtdGraphic.addAll({nameGraphic: qtd});
    });
    //?-----------------------------------------------
    //--- Total e Valor Máximo
    //--- Organizando Coordenadas
    double max = 0;
    qtdGraphic.forEach((key, value) {
      double index = typesGraphic.indexOf(key).toDouble();
      graphicCoordinates.addAll({
        key: [index, (value as int).toDouble()],
      });
      //Total | Max
      totalGraphic += value;
      double valor = (value as int).ceilToDouble();
      if (valor >= max) {
        max = valor;
      }
    });
    maxValueGraphic = max;
  }

  //* Coordenadas
  List<LineChartBarData> showDataCoordinates() {
    List<FlSpot> listCoordinates = [];
    graphicCoordinates.forEach((key, value) { 
      listCoordinates.add(
        FlSpot(value[0], value[1]),
      );
    });
    return [
      LineChartBarData(
        spots: listCoordinates,
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ];
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
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              color: Color(0xff232d37),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 20.0, left: 2.0, top: 24, bottom: 12),
              child: StreamBuilder<Object>(
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

                      defaultWidget = LineChart(
                        showAvg ? avgData() : mainData(),
                      );
                    }
                  } else {
                    defaultWidget = Container();
                  }
                  return defaultWidget;
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
                  child: SizedBox(
            width: 60,
            height: 34,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'AVG',
                style: TextStyle(
                    fontSize: 12,
                    color:
                        showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: _getTitlesData,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: _getTitlesDataLeft,
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: maxValueGraphic + 1,
      lineBarsData: showDataCoordinates(),
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: _getTitlesData,
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: _getTitlesDataLeft,
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: maxValueGraphic + 1,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(1, 3.44),
            FlSpot(2, 3.44),
            FlSpot(3, 3.44),
            FlSpot(5, 3.44),
            FlSpot(5, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  //* Titles
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

  String _getTitlesDataLeft(double value) {
    String title;
    qtdGraphic.forEach((key, valor) {
      if (value.toInt() == valor) {
        title = '$valor';
      }
    });
    return title;
  }
}
