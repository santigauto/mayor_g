import 'package:flutter/material.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';

class LevelPage extends StatelessWidget {
  final Map<String, double> dataMap = {'right': 5, 'wrong': 3};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Color(0xFF838547).withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: size.height*0.2,
                            width: size.height*0.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/Bronce.png'),
                                )
                            ),),
                          Container(
                            height: size.height*0.15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Nivel Actual', style: TextStyle(fontSize: 30, color: Colors.white),
                                ),
                                Text(
                                  'Bronce III', style: TextStyle(fontSize: 25, color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Color(0xFF838547).withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 5.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Proximo Nivel: - BRONCE II -',textAlign: TextAlign.start,style: TextStyle(color: Colors.white),),
                            ],
                          ),
                      LinearProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
                        value: 0.5,
                        semanticsLabel: 'Próximo Nivel',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('50/100 pts', textAlign: TextAlign.end,style: TextStyle(color: Colors.white))
                        ],
                      ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _cardText(text: Text('Ranking amigos',style:TextStyle(color: Colors.white))),
                        Card(
                          shape: StadiumBorder(),
                          color:Theme.of(context).primaryColor,
                          child:Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('4°',style:TextStyle(color: Colors.white)),
                          )
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        _cardText(text: Text('Ranking global',style:TextStyle(color: Colors.white))),
                        Card(
                          shape: StadiumBorder(),
                          color:Theme.of(context).primaryColor,
                          child:Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('5°',style:TextStyle(color: Colors.white)),
                          )
                        )
                      ],
                    ),
                  ],
                ),
                ],
              ),
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
          children: <Widget>[
            text
          ],
        ),
      ),
    );
  }

}
