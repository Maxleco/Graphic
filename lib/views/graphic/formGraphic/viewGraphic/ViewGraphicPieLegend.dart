import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:graphic/views/graphic/formGraphic/FormGraphicPieLegend.dart';

// ignore: must_be_immutable
class ViewGraphicPieLegend extends StatelessWidget {
  List listDados;
  List<charts.Series> seriesList;
  bool animate;

  ViewGraphicPieLegend(this.listDados) {
    this.seriesList = initGraphic();
  }

  ViewGraphicPieLegend.fromMap(Map<String, dynamic> map) {
    List<CoronaRegion> data = [];
    data.add(
      CoronaRegion(
        region: map["region1"],
        value: map["value1"],
      ),
    );
    data.add(
      CoronaRegion(
        region: map["region2"],
        value: map["value2"],
      ),
    );
    data.add(
      CoronaRegion(
        region: map["region3"],
        value: map["value3"],
      ),
    );
    data.add(
      CoronaRegion(
        region: map["region4"],
        value: map["value4"],
      ),
    );
    data.add(
      CoronaRegion(
        region: map["region5"],
        value: map["value5"],
      ),
    );
    this.listDados = data;
    this.seriesList = initGraphic();
  }

  List<charts.Series<CoronaRegion, String>> initGraphic() {
    return [
      new charts.Series<CoronaRegion, String>(
        id: 'Sales',
        // colorFn: (CoronaRegion CoronaRegion, __) ;,
        colorFn: (CoronaRegion coronaRegion, __) {
          var color;
          if (listDados.indexOf(coronaRegion) == 0) {
            color = charts.MaterialPalette.yellow.shadeDefault;
          } else if (listDados.indexOf(coronaRegion) == 1) {
            color = charts.MaterialPalette.green.shadeDefault;
          } else if (listDados.indexOf(coronaRegion) == 2) {
            color = charts.MaterialPalette.deepOrange.shadeDefault;
          } else if (listDados.indexOf(coronaRegion) == 3) {
            color = charts.MaterialPalette.gray.shadeDefault;
          } else if (listDados.indexOf(coronaRegion) == 4) {
            color = charts.MaterialPalette.blue.shadeDefault;
          }
          return color;
        },
        domainFn: (CoronaRegion coronaRegion, _) => coronaRegion.region,
        measureFn: (CoronaRegion coronaRegion, _) => coronaRegion.value,
        data: this.listDados,
        // Set a label accessor to control the text of the arc label.
        // labelAccessorFn: (CoronaRegion row, _) => '${row.value}',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: listDados != null
            ? Container(
                height: 300,
                child: charts.PieChart(
                  seriesList,
                  animate: animate,
                  behaviors: [
                    new charts.DatumLegend(
                      position: charts.BehaviorPosition.bottom,
                      horizontalFirst: false,
                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      showMeasures: true,
                      legendDefaultMeasure:
                          charts.LegendDefaultMeasure.firstValue,
                      
                      measureFormatter: (num value) {
                        return value == null ? '-' : '$value';
                      },
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
