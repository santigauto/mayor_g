import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';

class RankingPage extends StatelessWidget {
  final Map<String, double> dataMap = {'Correcto': 5, 'Incorrecto': 3};
  //TODO: falta sevicio del back que traiga estadisticas
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                _cardText(
                    text: Text(
                  'Porcentaje de respuestas correctas',
                  style: TextStyle(color: Colors.white),
                )),
                Container(
                  child: PieChart(
                    initialAngleInDegree: 0,
                    legendOptions: LegendOptions(
                      legendTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    colorList: [Theme.of(context).primaryColor, Colors.red],
                    dataMap: dataMap,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValuesInPercentage: true,
                      chartValueStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    ),
                    animationDuration: Duration(milliseconds: 800),
                )),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _cardText(
                            text: Text('Preguntas respondidas',
                                style: TextStyle(color: Colors.white))),
                        Card(
                            shape: StadiumBorder(),
                            color: Color(0xFF838547),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('36',
                                  style: TextStyle(color: Colors.white)),
                            ))
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        _cardText(
                            text: Text('Partidas jugadas',
                                style: TextStyle(color: Colors.white))),
                        Card(
                            shape: StadiumBorder(),
                            color: Color(0xFF838547),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('10',
                                  style: TextStyle(color: Colors.white)),
                            ))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardText({text: Text}) {
    return Card(
      color: Color(0xFF838547).withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[text],
        ),
      ),
    );
  }
}
