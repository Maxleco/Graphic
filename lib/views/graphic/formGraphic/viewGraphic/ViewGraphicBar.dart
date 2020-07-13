import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:graphic/views/graphic/formGraphic/FormGraphicBar.dart';

// ignore: must_be_immutable
class ViewGraphicBar extends StatelessWidget {
  List listDados;
  List<charts.Series> seriesList;
  bool animate;

  ViewGraphicBar(this.listDados){
    this.seriesList = initGraphic();
  }

  ViewGraphicBar.fromMap(Map<String, dynamic> map){
    List<DailyIncome> data = [];
    data.add(DailyIncome("Segunda", map["segunda"]));
    data.add(DailyIncome("Terça", map["terca"]));
    data.add(DailyIncome("Quarta", map["quarta"]));
    data.add(DailyIncome("Quinta", map["quinta"]));
    data.add(DailyIncome("Sexta", map["sexta"]));
    this.listDados = data;
    this.seriesList = initGraphic();
  }

  List<charts.Series<DailyIncome, String>> initGraphic(){
    return [
      new charts.Series<DailyIncome, String>(
        id: 'Profit Day',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (DailyIncome porfitDay, _) => porfitDay.day,
        measureFn: (DailyIncome porfitDay, _) => porfitDay.value,        
        data: this.listDados,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: listDados != null
            ? Container(
              height: 300,
              child: charts.BarChart(
                  seriesList,
                  animate: animate,
                ),
            )
            : Container(),
      ),
    );
  }
}
