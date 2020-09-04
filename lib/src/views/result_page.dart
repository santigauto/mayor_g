import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
/* import 'package:mayor_g/src/models/profileInfo.dart'; */
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/views/side_menu_options/collab_page.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/widgets/loading_widget.dart';

class _Bloc{
  StreamController _controller = StreamController.broadcast();

    Function get streamSink => _controller.sink.add;

    Stream get streamStream => _controller.stream;

    void disposeStreams() { 
      _controller.close();
    }
}

class ResultPage extends StatelessWidget {

    

  @override
  Widget build(BuildContext context) {


  final Map mapa = ModalRoute.of(context).settings.arguments;
  bool resultado = mapa['resultado'];
  int n = mapa['n'] + 1;
  ListaPreguntasNuevas questions= mapa['questions'];
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  String imagen ;

  _Bloc streamBloc = _Bloc();

  if(questions.preguntas[n-1].unirConFlechas) {
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
      case 2:
        imagen = 'assets/MayorGAnimaciones/MayorG-aplaude.gif';
        break;
      default: imagen = 'assets/MayorGAnimaciones/MayorG-Celebra.gif';
    }
  }
  else if (resultado) {imagen = 'assets/MayorGAnimaciones/mayorContento.gif';} 
  else{imagen = 'assets/MayorGAnimaciones/mayorEnojado.gif';}
  
  
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
            streamBloc.streamSink(true);
            if (n % 5 == 0 /* && n % 10 != 0 */ && n != 0){
              var aux = await QuestionServicePrueba().getNewQuestions(context, cantidad: 5);
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
                  width: size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imagen),fit: BoxFit.fill),
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
                        child: _resultadoText(questions, n, resultado, context, prefs, size),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40)
              ],
            ),
            StreamBuilder(
              stream: streamBloc.streamStream ,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Container(
                  child: (snapshot.data)
                  ? LoadingWidget(
                    caption: Text('Cargando pregunta, aguarde...',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _resultadoText(ListaPreguntasNuevas questions, n, resultado, context, prefs, size) {
    var paquete = questions.preguntas[n-1];
    if (resultado) {
      return BorderedText(
        strokeColor: Colors.green,
        child: Text('¡Correcto!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white)),
      );
    } else if (!paquete.unirConFlechas){
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
            tag: paquete.respuestaCorrecta,
              child: _respuesta(questions.preguntas[n-1], context, size)
          ),
        ],
      );
    }
    else{
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
          Text('${prefs.score}/4', style: TextStyle(color: Colors.white),),
        ],
      );
    }
  }
  Widget _respuesta(PreguntaNueva question, BuildContext context, Size size){
    if(question.imagenRespuesta == false){
      return Padding(
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
              question.respuestas[question.respuestaCorrecta],
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
        border: Border.all(
          width: 3,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          fit: BoxFit.fill,
          placeholder: AssetImage('assets/soldier.png'), 
          image: (MemoryImage(
              base64Decode(question.respuestas[question.respuestaCorrecta])
            )
          )
        ),
      ),
      height: size.width*0.45,
      width: size.width*0.45,
      );
    }
      
  }
}