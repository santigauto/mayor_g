
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/utils/friend_modal.dart';
import 'package:mayor_g/src/views/question_page.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/loading_widget.dart';
import 'package:mayor_g/src/widgets/pulse_animator.dart';
/* import 'package:mayor_g/src/widgets/scrollable_exhibition_bottom_sheet.dart'; */

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({Key key}) : super(key: key);

  @override
  _NewMatchPageState createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> with SingleTickerProviderStateMixin {
  final player = BackgroundMusic.backgroundAudioPlayer;
  bool _isLoading = false;
  bool _modoClasico = true;
  bool _modoDuelo = true;
  bool _selecOponente = true;
  bool _selecAlAzar = true;
  ListaPreguntasNuevas preguntas;
  AnimationController _animationController;
  Animation tamanio;
  //static BackgroundMusicBloc bloc;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    tamanio = Tween(begin: 0.0,end: 200.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
    super.initState();
  }
@override
void dispose() { 
  _animationController.dispose();
  super.dispose();
}
  Modal modal = new Modal();

  void _playAction() async {

    Navigator.pop(context);

    preguntas = await QuestionServicePrueba().getNewQuestions(context, cantidad: 10);

    if (preguntas == null) {
      setState(() {
        _isLoading = false;
      });
    } else {

      var route = new MaterialPageRoute(
          builder: (context) => QuestionPage(questions: preguntas, n: 0));
      Navigator.pushReplacement(context, route);
      await player.setAsset('assets/audios/Art_of_Silence.mp3').then((value) =>player.setLoopMode(LoopMode.one).then((value) => player.play()));

    }

  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    Color _noSeleccionado = Theme.of(context).primaryColor.withOpacity(0.2);
    Color _seleccionado = Theme.of(context).primaryColor;

    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _modoDeJuego(_seleccionado, _noSeleccionado, size),
                  SizedBox(
                    height: 20,
                  ),
                  _seleccionOponente(_seleccionado, _noSeleccionado, preguntas,size)
                ],
              ),
            ),
            (_isLoading)
            ? LoadingWidget(
              caption: Text('Cargando partida, aguarde...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
              )
            : Container()
          ],
        ),
      ),
    );
  }

  Widget _initMatchButton(context){
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return RaisedButton(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿Preparado?',style:Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                Container(
                  padding: EdgeInsets.all(5),
                  height: tamanio.value,
                  width: tamanio.value,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    image: DecorationImage(
                      image: AssetImage('assets/shape15.png'),
                    ),
                    ),
                  child: Center(
                    child: PulseAnimatorWidget(
                      begin: 0.5,
                      child: AutoSizeText(
                        '¡PRESIONE PARA JUGAR!', maxLines: 2,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _playAction();
            },
            disabledTextColor: Colors.grey,
          );
        }
      );
  }

  Widget _modoDeJuego(Color colorSelec, Color colorNoSelec, Size size) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: BorderedText(
                strokeColor: Colors.white,
                child: Text(
                  'Modo de Juego',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.white),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _boton(size, _modoClasico, "CLÁSICO", () {
                setState(() {
                  showDialog(context: context, child: _initMatchButton(context),);
                  _animationController.forward();
                  _modoClasico = true;
                  _modoDuelo = false;
                });
              }),
              _boton(size, _modoDuelo, "DUELO", () {
                setState(() {
                  _animationController.reset();
                  _modoDuelo = true;
                  _modoClasico = false;
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seleccionOponente(
      Color colorSelec, Color colorNoSelec, ListaPreguntasNuevas preguntas, Size size) {
    if (_modoDuelo && !_modoClasico) {
      return Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: BorderedText(
                strokeColor: Colors.white,
                child: Text(
                  'Oponente',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.white),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _boton(size, _selecOponente, "AMIGOS", () {
                  setState(() {
                    _animationController.reset();
                    _selecOponente = true;
                  });
                  modal.mainBottomSheet(context, preguntas);
                },),
              _boton(size, _selecAlAzar, "AL AZAR", () {
                  setState(() {
                    _selecOponente = false;
                    _animationController.forward();
                    showDialog(context: context, child: _initMatchButton(context),);
                    _selecAlAzar = true;
                  });
                }),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _boton(Size size, bool modo, String title, Function onTap){
    return Container(
      width: size.width*0.3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: (modo) ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.3),
          child: ListTile(
            title: AutoSizeText(title,maxLines: 1, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

}


