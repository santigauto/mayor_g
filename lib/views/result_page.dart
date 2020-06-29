import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/services/commons/questions_service.dart';
import 'package:mayor_g/views/side_menu_options/collab_page.dart';
import 'package:mayor_g/views/question_page.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/models/question_model.dart';

class ResultPage extends StatefulWidget {
  final bool resultado;
  final int n;
  final ListaPreguntas questions;
  ResultPage({Key key, this.resultado, this.n, this.questions})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String imagen;
  int n;
  ListaPreguntas questions;
  @override
  void initState() {
    super.initState();
    n = (widget.n) + 1;
    questions = widget.questions;
    
    if (widget.resultado) {
      imagen = 'assets/mayorContento.gif';
    } else
      imagen = 'assets/mayorEnojado.gif';
  }

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

  @override
  Widget build(BuildContext context) {
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
            var route = MaterialPageRoute(builder: (context) {
              return QuestionPage(
                n: n,
                questions: questions,
              );
            });
            Navigator.pushReplacement(context, route);
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
              onPressed: () {
                showDialog(
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
              },
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
                    color: Colors.black
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 15),
                        child: _resultadoText(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultadoText() {
    if (widget.resultado) {
      return BorderedText(
        strokeColor: Colors.green,
        child: Text('¡Correcto!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white)),
      );
    } else {
      return BorderedText(
        strokeColor: Colors.red,
        child: Text(
          'Incorrecto',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      );
    }
  }
}
