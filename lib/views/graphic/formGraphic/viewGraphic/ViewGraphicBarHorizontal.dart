import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:graphic/views/graphic/formGraphic/FormGraphicBarHorizontal.dart';

class ViewGraphicBarHorizontal extends StatelessWidget {
  List listDados;
  List<charts.Series> seriesList;
  bool animate;

  ViewGraphicBarHorizontal(this.listDados) {
    this.seriesList = initGraphic();
  }

  ViewGraphicBarHorizontal.fromMap(Map<String, dynamic> map) {
    List<IncomeByRegion> data = [];
    map.forEach((key, value) {
      if (key != "idUsuario" &&
            key != "titulo" &&
            key != "nomeUsuario" &&
            key != "emailUsuario") {
        data.add(IncomeByRegion(
          region: key,
          value: value,
        ));
      }
    });
    this.listDados = data;
    this.seriesList = initGraphic();
  }

  List<charts.Series<IncomeByRegion, String>> initGraphic() {
    return [
      new charts.Series<IncomeByRegion, String>(
        id: 'Profit Day',
        // measureOffsetFn: ,
        // radiusPxFn: (_, __) => 2,
        // domainLowerBoundFn: (IncomeByRegion porfitRegion, _) => porfitRegion.region,
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (IncomeByRegion porfitRegion, _) => porfitRegion.region,
        measureFn: (IncomeByRegion porfitRegion, _) => porfitRegion.value,
        labelAccessorFn: (IncomeByRegion porfitRegion, _) =>
            '${porfitRegion.region} | R\$ ${porfitRegion.value.toString()}',
        insideLabelStyleAccessorFn: (IncomeByRegion porfitRegion, _) {
          final color = (porfitRegion.value < 5)
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.yellow.shadeDefault.darker; 
          return new charts.TextStyleSpec(
            color: color,
            fontSize: 20,
          );
        },
        outsideLabelStyleAccessorFn: (IncomeByRegion porfitRegion, _) {
          final color = (porfitRegion.value < 5)
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.yellow.shadeDefault.darker; 
          return new charts.TextStyleSpec(
            color: color,
            fontSize: 20,
          );
        },
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
                  vertical: false,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.NoneRenderSpec()),
                ),
              )
            : Container(),
      ),
    );
  }
}
