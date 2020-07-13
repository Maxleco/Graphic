import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:graphic/views/graphic/formGraphic/FormGraphicLine.dart';

// ignore: must_be_immutable
class ViewGraphicLine extends StatelessWidget {
  List listDados;
  List<charts.Series> seriesList;
  bool animate;

  ViewGraphicLine(this.listDados) {
    this.seriesList = initGraphic();
  }

  ViewGraphicLine.fromMap(Map<String, dynamic> map) {
    List<QuarterlyAverage> data = [];
    data.add(
      QuarterlyAverage(
        date: DateTime.fromMicrosecondsSinceEpoch(
          (map["data1"] as Timestamp).microsecondsSinceEpoch,
        ),
        value: map["value1"],
      ),
    );
    data.add(
      QuarterlyAverage(
        date: DateTime.fromMicrosecondsSinceEpoch(
          (map["data2"] as Timestamp).microsecondsSinceEpoch,
        ),
        value: map["value2"],
      ),
    );
    data.add(
      QuarterlyAverage(
        date: DateTime.fromMicrosecondsSinceEpoch(
          (map["data3"] as Timestamp).microsecondsSinceEpoch,
        ),
        value: map["value3"],
      ),
    );
    data.add(
      QuarterlyAverage(
        date: DateTime.fromMicrosecondsSinceEpoch(
          (map["data4"] as Timestamp).microsecondsSinceEpoch,
        ),
        value: map["value4"],
      ),
    );
    this.listDados = data;
    this.seriesList = initGraphic();
  }

  List<charts.Series<QuarterlyAverage, DateTime>> initGraphic() {
    final defaultSeries = [
      QuarterlyAverage(date: DateTime(2020, 01, 28), value: 50),
      QuarterlyAverage(date: DateTime(2020, 05, 28), value: 100),
      QuarterlyAverage(date: DateTime(2020, 08, 28), value: 150),
      QuarterlyAverage(date: DateTime(2020, 12, 28), value: 200),
    ];
    return [
      new charts.Series<QuarterlyAverage, DateTime>(
        id: 'Quarterly Average',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (QuarterlyAverage quarterlyAverage, _) =>
            quarterlyAverage.date,
        measureFn: (QuarterlyAverage quarterlyAverage, _) =>
            quarterlyAverage.value,
        data: this.listDados,
      ),
      new charts.Series<QuarterlyAverage, DateTime>(
        id: 'Quarterly Average',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        dashPatternFn: (_, __) => [3, 2],
        domainFn: (QuarterlyAverage quarterlyAverage, _) =>
            quarterlyAverage.date,
        measureFn: (QuarterlyAverage quarterlyAverage, _) =>
            quarterlyAverage.value,
        data: defaultSeries,
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
                child: charts.TimeSeriesChart(
                  seriesList,
                  animate: animate,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  domainAxis: new charts.DateTimeAxisSpec(
                    tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                      day: new charts.TimeFormatterSpec(
                          format: 'dd', transitionFormat: 'dd/MM/yyyy'),
                      month:  new charts.TimeFormatterSpec(
                          format: 'dd/MM', transitionFormat: 'dd/MM/yyyy'),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
