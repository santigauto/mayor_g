import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';

import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/services/commons/questions_service.dart';

import 'package:mayor_g/src/views/question_page.dart';
import 'package:mayor_g/src/views/side_menu_options/collab_page.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';

class _Bloc {
  StreamController _controller = StreamController.broadcast();

  Function get streamSink => _controller.sink.add;

  Stream get streamStream => _controller.stream;

  void disposeStreams() {
    _controller.close();
  }
}

class ResultPage extends StatelessWidget {
  static List<PreguntaRespondida> preguntasRespondidas;

  @override
  Widget build(BuildContext context) {
    if (preguntasRespondidas == null) {
      preguntasRespondidas = [];
    }

    final player = BackgroundMusic.backgroundAssetsAudioPlayer;
    final Map mapa = ModalRoute.of(context).settings.arguments;
    bool resultado = mapa['resultado'];
    int n = mapa['n'] + 1;
    ListaPreguntasNuevas questions = mapa['questions'];

    int puntaje = 0;

    PreferenciasUsuario prefs = new PreferenciasUsuario();
    String imagen;
    _Bloc streamBloc = _Bloc();

    if (questions.preguntas[n - 1].unirConFlechas) {
      puntaje = prefs.score;
      switch (prefs.score) {
        case 0:
          imagen = 'assets/MayorGAnimaciones/MayorG-Frustrado.gif';
          break;
        case 1:
          imagen = 'assets/MayorGAnimaciones/MayorG-Regaña.gif';
          break;
        case 2:
          imagen = 'assets/MayorGAnimaciones/MayorG-aplasta.gif';
          break;
        case 3:
          imagen = 'assets/MayorGAnimaciones/MayorG-aplaude.gif';
          break;
        default:
          imagen = 'assets/MayorGAnimaciones/MayorG-Celebra.gif';
      }
    } else if (resultado) {
      puntaje = 1;
      imagen = 'assets/MayorGAnimaciones/mayorContento.gif';
    } else {
      puntaje = 0;
      imagen = 'assets/MayorGAnimaciones/mayorEnojado.gif';
    }

    PreguntaRespondida preguntaResp = new PreguntaRespondida(
        id: questions.preguntas[n - 1].id, puntaje: puntaje);
    preguntasRespondidas.add(preguntaResp);

Future<bool> _back() {

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('¿Quieres realmente abandonar la partida?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: Text('Salir')),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('Cancelar'))
    ],
  ));

}

    Future<void> _salir() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('¿Realmente quiere abandonar la partida?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/');
                await player
                  .open(Audio('assets/audios/Background_Music.mp3'),loopMode: LoopMode.none)
                  .then((value) => player.play());
              },
              child: Text('Salir')),
            TextButton(
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
                  return CollabPage(isCollab: false, id: questions.preguntas[n - 1].id);
                });
                Navigator.push(context, route);
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.4,
                      width: size.height * 0.4,
                      decoration: BoxDecoration(
                        //color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage(imagen), fit: BoxFit.fill),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15),
                            child: _resultadoText(questions, n, resultado,
                                context, prefs, size),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 30,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 25,
                    spreadRadius: 5,
                  )
                ]),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      streamBloc.streamSink(true);
                      int largo = questions.preguntas.length;
                      if (n == (largo - 5)) {
                        var aux = await QuestionServicePrueba()
                            .getNewQuestions(context, cantidad: 10);
                        questions.preguntas.addAll(aux.preguntas);
                        for (int i = 0; i < (largo - 5); i++) {
                          questions.preguntas.removeAt(0);
                          n--;
                        }
                      }
                      var route = MaterialPageRoute(
                          builder: (context) =>
                              QuestionPage(questions: questions, n: n));
                      Navigator.pushReplacement(context, route);
                    },
                    label: PulseAnimatorWidget(
                        begin: 0.5, child: Icon(Icons.arrow_forward_ios)),
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PulseAnimatorWidget(
                          begin: 0.5, child: Text('Continuar',style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: streamBloc.streamStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  child: (snapshot.data)
                      ? LoadingWidget(
                          caption: Text('Cargando pregunta, aguarde...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        )
                      : Container(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultadoText(
      ListaPreguntasNuevas questions, n, resultado, context, prefs, size) {
    var paquete = questions.preguntas[n - 1];
    if (resultado) {
      return BorderedText(
        strokeColor: Colors.green,
        child: Text('¡Correcto!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white)),
      );
    } else if (!paquete.unirConFlechas) {
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
          Text(
            'La respuesta era:',
            style: TextStyle(color: Colors.white),
          ),
          Hero(
              tag: (questions.preguntas[n - 1].respuestaCorrecta * (n)) + n - 1,
              child: _respuesta(questions.preguntas[n - 1], context, size)),
        ],
      );
    } else {
      return Column(
        children: [
          BorderedText(
            strokeColor: Colors.amber[600],
            child: Text(
              'Acertaste',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          Text(
            '${prefs.score}/4',
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
    }
  }

  Widget _respuesta(PreguntaNueva question, BuildContext context, Size size) {
    if (question.imagenRespuesta == false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
        child: Container(
          width: double.infinity,
          child: MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            disabledColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
            ),
            onPressed: null,
            child: AutoSizeText(
              question.respuestas[question.respuestaCorrecta],
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3, color: Theme.of(context).primaryColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
              fit: BoxFit.fill,
              placeholder: AssetImage('assets/soldier.png'),
              image: (MemoryImage(base64Decode(
                  question.respuestas[question.respuestaCorrecta])))),
        ),
        height: size.width * 0.45,
        width: size.width * 0.45,
      );
    }
  }
}
