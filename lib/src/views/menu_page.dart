import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
/* import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart'; */

import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/custom_header_widget.dart';
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
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            HeaderCurvo(),
            SafeArea(
              child: Builder(
                builder: (context) => IconButton(
                  color: Colors.white,
                  icon: new Icon(Icons.menu),
                  onPressed: () /* async{
                    ListaPreguntasNuevas hola = await QuestionServicePrueba().getNewQuestions(context, cantidad: 2);
                    print('${hola.preguntas[0].pregunta}');
                  } , */
                    =>Scaffold.of(context).openDrawer()
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _logoMenu(size),
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
                'assets/MayorG-Fumando.gif',
                color: Colors.black,
              ),
            ),
          ),
        ),
        Container(
          height: 310,
          width: 250,
          child: Image.asset(
            'assets/MayorG-Fumando.gif',
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
