import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/views/side_menu_options/collab_page.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/models/question_model.dart';

class ResultPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final Map mapa = ModalRoute.of(context).settings.arguments;
  bool resultado = mapa['resultado'];
  int n = mapa['n'] + 1;
  ListaPreguntas questions= mapa['questions'];
  String imagen =(resultado)? 'assets/MayorGAnimaciones/mayorContento.gif':'assets/MayorGAnimaciones/mayorEnojado.gif';

  /* if (widget.resultado) {
      imagen = 'assets/MayorGAnimaciones/mayorContento.gif';
    } else
      imagen = 'assets/MayorGAnimaciones/mayorEnojado.gif';
  } */
  
  Future<bool> _back() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
      title: Text('¿Quieres realmente abandonar la partida?'),
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

  Future<void> _salir(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Realmente quiere abandonar la partida?'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Salir')),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'))
        ],
      ));
  }
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async{
            if (n % 5 == 0 && n % 10 != 0 && n != 0){
              var aux = await QuestionsService().getQuestions(context, dni: PreferenciasUsuario().dni);
              questions.preguntas.addAll(aux.preguntas);
            }
            Navigator.pushReplacementNamed(context, 'question', arguments: {'n':n , 'questions': questions});
          },
          icon: Icon(Icons.keyboard_arrow_right),
          label: Text('Seguir'),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          actions: <Widget>[
            MaterialButton(
              child: Text(
                'Salir',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _salir,
            ),
            Expanded(child: Container()),
            MaterialButton(
              child: Text('Reportar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                var route = MaterialPageRoute(builder: (context) {
                  return CollabPage(collabOrReport: 'Reportar', id: 3);
                });
                Navigator.push(context, route);
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imagen)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 15),
                        child: _resultadoText(questions, n, resultado, context),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height*0.15,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultadoText(questions, n, resultado, context) {
    if (resultado) {
      return BorderedText(
        strokeColor: Colors.green,
        child: Text('¡Correcto!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white)),
      );
    } else {
      return Column(
        children: <Widget>[
          BorderedText(
            strokeColor: Colors.red,
            child: Text(
              'Incorrecto',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          Text('La respuesta era:', style: TextStyle(color: Colors.white),),
          Hero(
            tag: questions.preguntas[n-1].respuestaCorrecta,
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0, horizontal: 8),
              child: Container(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  disabledColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
                  ),
                  onPressed: null,
                  child: Text(
                    questions.preguntas[n-1].respuestas[questions.preguntas[n-1].respuestaCorrecta],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
