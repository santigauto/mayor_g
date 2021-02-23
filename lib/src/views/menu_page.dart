import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';

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
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            HeaderCurvo(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _logoMenu(size),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: Offset(0,10.0, // Move to bottom 10 Vertically
                          ),)
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: PulseAnimatorWidget(
                              begin:0.5,
                              child: AutoSizeText("Comenzar Juego", style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                            onTap: () {
                            Navigator.pushNamed(context, 'new_match');
                          },
                          ),
                        ),
                      ),
                      ),
                    
                    SizedBox(
                      height: 30,
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

  Widget _logoMenu(Size size){
    return Stack(
      children: <Widget>[
        Positioned(
          left: 30,
          child: Opacity(
            opacity: 0.6,
            child: Container(
              height: 310,
              width: 250,
              child: Image.asset(
                'assets/MayorGAnimaciones/MayorG-Fumando.gif',
                color: Colors.black,
              ),
            ),
          ),
        ),
        Container(
          height: 310,
          width: 250,
          child: Image.asset(
            'assets/MayorGAnimaciones/MayorG-Fumando.gif',
          ),),
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
    );
  }
}
