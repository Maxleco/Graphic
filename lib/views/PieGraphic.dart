import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:graphic/widgets/Indicator.dart';

// ignore: must_be_immutable
class PieGraphic extends StatefulWidget {
  List<String> namesGraphics;
  List<String> titlesGraphics;
  PieGraphic({this.namesGraphics, this.titlesGraphics});
  @override
  _PieGraphicState createState() => _PieGraphicState();
}

class _PieGraphicState extends State<PieGraphic> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  int touchedIndex;
  int totalGraphic;
  List<String> typesGraphic;
  List<String> titlesGraphic;
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
    qtdGraphic.forEach((key, value) {
      totalGraphic += value;
    });
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> listWidget = [];
    qtdGraphic.forEach((key, value) {
      int index;
      Color cor;
      if (key == typesGraphic[0]) {
        cor = Color(0xff0293ee);
        index = 0;
      } else if (key == typesGraphic[1]) {
        cor = Color(0xfff8b250);
        index = 1;
      } else if (key == typesGraphic[2]) {
        cor = Color(0xff845bef);
        index = 2;
      } else if (key == typesGraphic[3]) {
        cor = Color(0xff13d38e);
        index = 3;
      } else if (key == typesGraphic[4]) {
        cor = Color(0xffcc008e);
        index = 4;
      } else if (key == typesGraphic[5]) {
        cor = Color(0xffbbf8cc);
        index = 5;
      }
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 25 : 15;
      final double radius = isTouched ? 60 : 50;
      final double valor = double.tryParse(
        ((value * 100) / totalGraphic as double).toStringAsFixed(1),
      );

      listWidget.add(
        PieChartSectionData(
          color: cor,
          value: valor,
          title: value == 0 ? '' : '$valor %',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        ),
      );
    });
    return listWidget;
  }

  @override
  void initState() {
    super.initState();
    _recuperandoDadosGraficos();
    // data = widget.dados;
    typesGraphic = widget.namesGraphics;
    titlesGraphic = widget.titlesGraphics;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
     
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
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
              } else if (snapshot.connectionState == ConnectionState.active) {
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
                  List<DocumentSnapshot> qtdDocuments = querySnapshot.documents;
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
            },
          ),
        ),
      ),
    );
  }

  Widget _getGraphic() {
    return Row(
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                setState(() {
                  if (pieTouchResponse.touchInput is FlLongPressEnd ||
                      pieTouchResponse.touchInput is FlPanEnd) {
                    touchedIndex = -1;
                  } else {
                    touchedIndex = pieTouchResponse.touchedSectionIndex;
                  }
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 50,
              sections: showingSections(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
                  child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getLegends(),
          ),
        ),
      ],
    );
  }

  List<Widget> _getLegends() {
    List<Widget> listWidget = [];
    qtdGraphic.forEach((key, value) {
      Color cor;
      String title;
      if (key == typesGraphic[0]) {
        cor = Color(0xff0293ee);
        title = titlesGraphic[0];
      } else if (key == typesGraphic[1]) {
        cor = Color(0xfff8b250);
        title = titlesGraphic[1];
      } else if (key == typesGraphic[2]) {
        cor = Color(0xff845bef);
        title = titlesGraphic[2];
      } else if (key == typesGraphic[3]) {
        cor = Color(0xff13d38e);
        title = titlesGraphic[3];
      } else if (key == typesGraphic[4]) {
        cor = Color(0xffcc008e);
        title = titlesGraphic[4];
      } else if (key == typesGraphic[5]) {
        cor = Color(0xffbbf8cc);
        title = titlesGraphic[5];
      }
      listWidget.add(
        Indicator(
          color: cor,
          text: title,
          isSquare: true,
        ),
      );
      listWidget.add(SizedBox(height: 4));
    });
    listWidget.add(SizedBox(height: 14));
    return listWidget;
  }
}
