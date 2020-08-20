import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/side_menu_widget.dart';

class MenuPage extends StatelessWidget{
  

  @override
  Widget build(BuildContext context) {

  Future<bool> _back() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quieres realmente salir de Mayor G'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Salir')),
          FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Cancelar'))
        ],
      ));
  }


    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        drawer: Container(width: 300, child: SideMenuWidget()),
        appBar: AppBar(
          title: Text('MayorG App'),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.6,
                          child: Container(
                            padding: EdgeInsets.only(left: size.width * 0.05),
                            height: 310,
                            width: 250,
                            child: Image.asset(
                              'assets/MayorG-Fumando.gif',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: size.width * 0.5),
                          height: 310,
                          width: 250,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/MayorG-Fumando.gif'))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 215),
                          child: Container(
                            height: 100,
                            width: 250,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/mayorG@3x.png'))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Comenzar", style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'new_match');
                      },
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.green[900],
                      shape: StadiumBorder(),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
