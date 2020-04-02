import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/award@3x.png'))),
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      _cardText(text:Text('Ranking Actual',style: TextStyle(fontSize: 26,color: Colors.white))),
                      _cardText(text:Text('22',style: TextStyle(fontSize: 26,color: Colors.white)))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardText({text: Text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: text
    );
  }
}
