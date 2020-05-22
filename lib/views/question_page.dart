//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mayor_g/models/navegador_argumentos.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class QuestionPage extends StatefulWidget {
  final ListaPreguntas questions;
  final int n;
  const QuestionPage({Key key, this.questions, this.n}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin {

  AnimationController controller;
  bool aux = false;
  String imagen;

  @override
  void initState() {
    super.initState();
    
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );
    controller.reverse(
      from: controller.value == 0 ? 1 : controller.value,
    );
    controller.addStatusListener((state) {
      if (aux == true) {
        Navigator.pop(context);
      }
      return Navigator.pushReplacementNamed(context, 'result',
          arguments: ModalRoute.of(context).settings.arguments);
    });
  }

  Future<bool> _back() {
    aux = true;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Quieres realmente salir de Mayor G'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      aux = false;
                    },
                    child: Text('Salir')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                      aux = false;
                    },
                    child: Text('Cancelar'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    imagen = widget.questions.preguntas[widget.n].pregunta.foto;
    print(imagen);
    ArgumentosResultado _argumentos = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;
    print(
        'questionPage: ${widget.questions.preguntas[widget.n].pregunta.pregunta}');
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                SafeArea(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: size.height * 0.12,
                      child: TimerWidget(controller: controller)),
                ),
                _pregunta(size),
                _foto(size),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _respuestas(_argumentos),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _pregunta(Size size){

    double d;
    if(imagen == '' || imagen == null || imagen == 'null')d = 0.3;
    else d = 0.15;
    return Container(
      height: size.height*d,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Text(
          widget.questions.preguntas[widget.n].pregunta.pregunta,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        )),
      ),
    );

  }

  Widget _foto(Size size) {
    if (imagen == '' || imagen == null || imagen == 'null') {
      return Container();
    } else
      return Container(
        height: size.height * 0.2,
        decoration: BoxDecoration(
            image: DecorationImage(image: MemoryImage(base64Decode(imagen))),
            shape: BoxShape.rectangle),
      );
  }

  List<Widget> _respuestas(argumentos) {
    final List<Widget> answers = [];
    List<dynamic> aux = [];


    for (var i = 0;
        i < widget.questions.preguntas[widget.n].respuestas.length;
        i++) {
      aux.add({
        'respuesta': '${widget.questions.preguntas[widget.n].respuestas[i]}',
        'id': i
      });
    }

    for (var i = 0; i < aux.length; i++) {
      answers.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 5)),
        child: ListTile(
          onTap: () {
            if (aux[i]['id'] !=
                widget.questions.preguntas[widget.n].respuestaCorrecta) {
              Navigator.pushReplacementNamed(context, 'result',
                  arguments: argumentos);
            } else {
              Navigator.pushReplacementNamed(context, 'result',
                  arguments: ArgumentosResultado(
                      preguntas: widget.questions,
                      n: widget.n,
                      resultado: true));
            }
          },
          title: Text(
            aux[i]['respuesta'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ));
    }

    return answers;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
