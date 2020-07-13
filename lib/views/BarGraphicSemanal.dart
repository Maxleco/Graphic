import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:graphic/util/Configuracoes.dart';

// ignore: must_be_immutable
class BarGraphicSemanal extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  _BarGraphicSemanalState createState() => _BarGraphicSemanalState();
}

class _BarGraphicSemanalState extends State<BarGraphicSemanal> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;
  bool isPlaying = false;

  List<String> daysOfTheWeek;
  List<String> abvDaysOfTheWeek;

  @override
  void initState() {
    super.initState();
    daysOfTheWeek = Configuracoes.daysOfTheWeek;
    abvDaysOfTheWeek = Configuracoes.abvDaysOfTheWeek;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xff81e5cd),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Semanal',
                    style: TextStyle(
                      color: const Color(0xff0f4a3c),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Courier New",
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Gráfico de consumo de calorias',
                    style: TextStyle(
                      color: const Color(0xff379982),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Courier New",
                    ),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xff0f4a3c),
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey, getTooltipItem: _getTooltipItem),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: _getTitlesData,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: _getTitlesData,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroupsRandom(),
    );
  }

  //* Show Groups
  List<BarChartGroupData> showingGroups() {
    List<BarChartGroupData> listWidget = [];
    daysOfTheWeek.forEach((element) {
      int x;
      double y;
      int index = daysOfTheWeek.indexOf(element);
      switch (index) {
        case 0:
          x = 0;
          y = 5;
          break;
        case 1:
          x = 1;
          y = 6.5;
          break;
        case 2:
          x = 2;
          y = 5;
          break;
        case 3:
          x = 3;
          y = 7.5;
          break;
        case 4:
          x = 4;
          y = 9;
          break;
        case 5:
          x = 5;
          y = 11.5;
          break;
        case 6:
          x = 6;
          y = 6.5;
          break;
        default:
          return null;
      }
      listWidget.add(
        BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(
              y: index == touchedIndex ? y + 1 : y,
              color: index == touchedIndex ? Colors.yellow : Colors.white,
              width: 22,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                y: 20,
                color: barBackgroundColor,
              ),
            ),
          ],
          showingTooltipIndicators: [],
        ),
      );
    });
    return listWidget;
  }

  List<BarChartGroupData> showingGroupsRandom() {
    List<BarChartGroupData> listWidget = [];
    daysOfTheWeek.forEach((element) {
      int x;
      double y = Random().nextInt(15).toDouble() + 6;
      int index = daysOfTheWeek.indexOf(element);
      switch (index) {
        case 0:
          x = 0;
          break;
        case 1:
          x = 1;
          break;
        case 2:
          x = 2;
          break;
        case 3:
          x = 3;
          break;
        case 4:
          x = 4;
          break;
        case 5:
          x = 5;
          break;
        case 6:
          x = 6;
          break;
        default:
          return null;
      }
      listWidget.add(
        BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(
              y: index == touchedIndex ? y + 1 : y,
              color: index == touchedIndex
                  ? Colors.yellow
                  : widget.availableColors[
                      Random().nextInt(widget.availableColors.length)],
              width: 22,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                y: 20,
                color: barBackgroundColor,
              ),
            ),
          ],
          showingTooltipIndicators: [],
        ),
      );
    });
    return listWidget;
  }

  //* Titles
  //----------------------------------------------------------
  //----------------------------------------------------------
  String _getTitlesData(double value) {
    switch (value.toInt()) {
      case 0:
        return abvDaysOfTheWeek[0];
      case 1:
        return abvDaysOfTheWeek[1];
      case 2:
        return abvDaysOfTheWeek[2];
      case 3:
        return abvDaysOfTheWeek[3];
      case 4:
        return abvDaysOfTheWeek[4];
      case 5:
        return abvDaysOfTheWeek[5];
      case 6:
        return abvDaysOfTheWeek[6];
      default:
        return '';
    }
  }

  BarTooltipItem _getTooltipItem(
    BarChartGroupData groupData,
    int groupIndex,
    BarChartRodData rodData,
    int rodIndex,
  ) {
    String weekDay;
    switch (groupData.x.toInt()) {
      case 0:
        weekDay = daysOfTheWeek[0];
        break;
      case 1:
        weekDay = daysOfTheWeek[1];
        break;
      case 2:
        weekDay = daysOfTheWeek[2];
        break;
      case 3:
        weekDay = daysOfTheWeek[3];
        break;
      case 4:
        weekDay = daysOfTheWeek[4];
        break;
      case 5:
        weekDay = daysOfTheWeek[5];
        break;
      case 6:
        weekDay = daysOfTheWeek[6];
        break;
    }
    return BarTooltipItem(
      weekDay + '\n' + (rodData.y - 1).toString(),
      TextStyle(
          color: Colors.amber,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: "Courier New"),
    );
  }

  //--------------------------------------------------
  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
