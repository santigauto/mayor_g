import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:mayor_g/widgets/background_widget.dart';

class RankingPage extends StatelessWidget {
  final Map<String, double> dataMap = {'right': 5, 'wrong': 3};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Ranking')),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height*0.1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/award@3x.png'))),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      _cardText(
                          text: Text('Ranking Actual',
                              style: TextStyle(
                                  fontSize: 26, color: Colors.white))),
                      _cardText(
                          text: Text('22',
                              style:
                                  TextStyle(fontSize: 26, color: Colors.white)))
                    ],
                  ),
                ),
                Container(
                    width: size.width * 0.7,
                    child: PieChart(
                      colorList: [Theme.of(context).primaryColor,Colors.red],
                      dataMap: dataMap,
                      showChartValueLabel: false,
                      chartValueStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      animationDuration: Duration(
                        seconds: 2
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardText({text: Text}) {
    return Padding(padding: const EdgeInsets.all(8.0), child: text);
  }
}
