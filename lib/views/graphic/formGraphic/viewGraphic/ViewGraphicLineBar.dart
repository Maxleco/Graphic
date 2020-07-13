import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:graphic/views/graphic/formGraphic/FormGraphicLineBar.dart';

// ignore: must_be_immutable
class ViewGraphicLineBar extends StatelessWidget {
  List listDados;
  List<charts.Series> seriesList;
  bool animate;

  ViewGraphicLineBar(this.listDados) {
    this.seriesList = initGraphic();
  }

  ViewGraphicLineBar.fromMap(Map<String, dynamic> map) {
    List<AverageGoals> data = [
      AverageGoals(
        player: map["player1"],
        goalsByYear: [
          GoalsByYear(year: "2017", value: map["values1"]["2017"]["value"]),
          GoalsByYear(year: "2018", value: map["values1"]["2018"]["value"]),
          GoalsByYear(year: "2019", value: map["values1"]["2019"]["value"]),
          GoalsByYear(year: "2020", value: map["values1"]["2020"]["value"]),
        ],
      ),
      AverageGoals(
        player: map["player2"],
        goalsByYear: [
          GoalsByYear(year: "2017", value: map["values2"]["2017"]["value"]),
          GoalsByYear(year: "2018", value: map["values2"]["2018"]["value"]),
          GoalsByYear(year: "2019", value: map["values2"]["2019"]["value"]),
          GoalsByYear(year: "2020", value: map["values2"]["2020"]["value"]),
        ],
      ),
      AverageGoals(
        player: map["player3"],
        goalsByYear: [
          GoalsByYear(year: "2017", value: map["values3"]["2017"]["value"]),
          GoalsByYear(year: "2018", value: map["values3"]["2018"]["value"]),
          GoalsByYear(year: "2019", value: map["values3"]["2019"]["value"]),
          GoalsByYear(year: "2020", value: map["values3"]["2020"]["value"]),
        ],
      ),
      AverageGoals(
        player: map["voce"],
        goalsByYear: [
          GoalsByYear(year: "2017", value: map["values4"]["2017"]["value"]),
          GoalsByYear(year: "2018", value: map["values4"]["2018"]["value"]),
          GoalsByYear(year: "2019", value: map["values4"]["2019"]["value"]),
          GoalsByYear(year: "2020", value: map["values4"]["2020"]["value"]),
        ],
      ),
    ];
    this.listDados = data;
    this.seriesList = initGraphic();
  }

  List<charts.Series<GoalsByYear, String>> initGraphic() {
    List<List<GoalsByYear>> data = [];
    for (var item in this.listDados as List<AverageGoals>) {
      data.add(item.goalsByYear);
    }
    print(data[3]);
    return [
      new charts.Series<GoalsByYear, String>(
        id: 'Jogador 1',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GoalsByYear goalsByYear, _) => goalsByYear.year,
        measureFn: (GoalsByYear goalsByYear, _) => goalsByYear.value,
        data: data[0],
      ),
      new charts.Series<GoalsByYear, String>(
        id: 'Jogador 2',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GoalsByYear goalsByYear, _) => goalsByYear.year,
        measureFn: (GoalsByYear goalsByYear, _) => goalsByYear.value,
        data: data[1],
      ),
      new charts.Series<GoalsByYear, String>(
          id: 'Jogador 3',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (GoalsByYear goalsByYear, _) => goalsByYear.year,
          measureFn: (GoalsByYear goalsByYear, _) => goalsByYear.value,
          data: data[2]),
      new charts.Series<GoalsByYear, String>(
          id: 'Você',
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
          domainFn: (GoalsByYear goalsByYear, _) => goalsByYear.year,
          measureFn: (GoalsByYear goalsByYear, _) => goalsByYear.value,
          data: data[3])
        // Configure our custom bar renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: listDados != null
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 350,
                    child: charts.OrdinalComboChart(
                      seriesList,
                      animate: animate,
                      defaultRenderer: new charts.BarRendererConfig(
                        groupingType: charts.BarGroupingType.grouped,
                      ),
                      customSeriesRenderers: [
                        new charts.LineRendererConfig(
                            customRendererId: 'customLine')
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.vertical,
                      runSpacing: 8,
                      children: this.listDados.map((element) {
                        int order = listDados.indexOf((element as AverageGoals));
                        Color cor = Colors.white;
                        if(order == 0){
                          cor = Colors.blue;
                        } else if(order == 1){
                          cor = Colors.red;
                        } else if(order == 2){
                          cor = Colors.green;
                        }else if(order == 3){
                          cor = Colors.purple;
                        }
                        String person = (element as AverageGoals).player;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: order == 3 ? 2 : 10,
                              width: 10,
                              color: cor,
                            ),
                            SizedBox(width: 15),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                person,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
