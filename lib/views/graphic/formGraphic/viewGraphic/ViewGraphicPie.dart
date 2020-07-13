import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../FormGraphicPie.dart';

// ignore: must_be_immutable
class ViewGraphicPie extends StatelessWidget {
  List listDados;
  List<charts.Series> seriesList;
  bool animate;

  ViewGraphicPie(this.listDados) {
    this.seriesList = initGraphic();
  }

  ViewGraphicPie.fromMap(Map<String, dynamic> map) {
    List<Placing> data = [];
    data.add(
      Placing(
        nome: map["name1"],
        value: map["value1"],
      ),
    );
    data.add(
      Placing(
        nome: map["name2"],
        value: map["value2"],
      ),
    );
    data.add(
      Placing(
        nome: map["name3"],
        value: map["value3"],
      ),
    );
    data.add(
      Placing(
        nome: map["name4"],
        value: map["value4"],
      ),
    );
    this.listDados = data;
    this.seriesList = initGraphic();
  }

  List<charts.Series<Placing, String>> initGraphic() {
    return [
      new charts.Series<Placing, String>(
        id: 'Sales',
        colorFn: (Placing placing, __) {
          var color;
          if (listDados.indexOf(placing) == 0) {
            color = charts.MaterialPalette.teal.shadeDefault;
          } else if (listDados.indexOf(placing) == 1) {
            color = charts.MaterialPalette.cyan.shadeDefault;
          } else if (listDados.indexOf(placing) == 2) {
            color = charts.MaterialPalette.deepOrange.shadeDefault;
          } else if (listDados.indexOf(placing) == 3) {
            color = charts.MaterialPalette.green.shadeDefault;
          }
          return color;
        },
        domainFn: (Placing placing, _) => placing.nome,
        measureFn: (Placing placing, _) => placing.value,
        data: this.listDados,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Placing row, _) => '${row.nome}: ${row.value}',
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
                  // defaultRenderer: new charts.ArcRendererConfig(
                  //   arcRendererDecorators: [
                  //     new charts.ArcLabelDecorator(
                  //         labelPosition: charts.ArcLabelPosition.outside)
                  //   ],
                  // ),
                  defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 110,
                    arcRendererDecorators: [new charts.ArcLabelDecorator(
                      insideLabelStyleSpec: new charts.TextStyleSpec(
                        fontSize: 14,
                        color: charts.MaterialPalette.white,
                      ),
                      outsideLabelStyleSpec: new charts.TextStyleSpec(
                        fontSize: 14,      
                      ),
                    )],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
