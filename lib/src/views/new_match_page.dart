
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/utils/friend_modal.dart';
import 'package:mayor_g/src/views/question_page.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({Key key}) : super(key: key);

  @override
  _NewMatchPageState createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> with TickerProviderStateMixin {
  final player = BackgroundMusic.backgroundAssetsAudioPlayer;
  bool _isLoading = false;
  bool _modoClasico = true;
  bool _modoDuelo = true;
  bool _selecOponente = true;
  bool _selecAlAzar = true;
  ListaPreguntasNuevas preguntas;
  AnimationController _animationController;
  Animation tamanio;
  AnimationController _animationControllerOponente;
  Animation fadeOponente;
  Animation translateOponente;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  //static BackgroundMusicBloc bloc;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    tamanio = Tween(begin: 0.0,end: 200.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));

    _animationControllerOponente = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fadeOponente = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationControllerOponente, curve: Curves.easeIn));
    translateOponente = Tween(begin: 0.0, end: 180.0).animate(CurvedAnimation(parent: _animationControllerOponente, curve: Curves.easeIn));
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
      player.open(Audio("assets/audios/Art_of_Silence.mp3"));
      player.loop=true;
      player.play();//setAsset('assets/audios/Art_of_Silence.mp3').then((value) =>player.setLoopMode(LoopMode.one).then((value) => player.play()));

    }

  }

  @override
  Widget build(BuildContext context) {


    back(){
      if(_modoDuelo == true && _modoClasico == false){
        _animationControllerOponente.reverse();
        _modoClasico = true;
        _selecOponente = true;
        _selecAlAzar = true;
        setState(() {});
      } else Navigator.pop(context);
    }


    Size size = MediaQuery.of(context).size;
    Color _noSeleccionado = Theme.of(context).primaryColor.withOpacity(0.2);
    Color _seleccionado = Theme.of(context).primaryColor;

    
    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            AnimatedBuilder(
              animation: _animationControllerOponente,
              builder:(context,_){
                return Positioned(
                  top: size.height * 0.35 - translateOponente.value,
                  child: SafeArea(child: _modoDeJuego(_seleccionado, _noSeleccionado, size)));
              }
            ),
            AnimatedBuilder(
              animation: _animationControllerOponente,
              builder: (context,_){
                return FadeTransition(
                  opacity: fadeOponente,
                  child: SafeArea(child: _seleccionOponente(_seleccionado, _noSeleccionado, preguntas, size),));
              }
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
          return MaterialButton(
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
          Container(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedBuilder(
                    animation: _animationControllerOponente,
                    builder: (context,_){
                      return Container(
                        width: size.width * (0.3 * (1 - fadeOponente.value)),
                        child: _boton(size, _modoClasico, "CLÁSICO", () {
                          showDialog(
                              context: context,
                              builder: (context){

                                return _initMatchButton(context);
                              }
                          );
                          _animationController.reset();
                          _animationController.forward();
                          setState(() {
                            _modoClasico = true;
                            _modoDuelo = false;
                          });
                        }),
                      );
                    }
                ),
                AnimatedBuilder(
                    animation: _animationControllerOponente,
                    builder:(context, _ )=> SizedBox(height: 10,width: size.width * (0.1 * (1 - fadeOponente.value)),)),
                _boton(size, _modoDuelo, "DUELO", () {
                  _animationControllerOponente.forward();
                  setState(() {
                    _animationController.reset();
                    _modoDuelo = true;
                    _modoClasico = false;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seleccionOponente(
      Color colorSelec, Color colorNoSelec, ListaPreguntasNuevas preguntas, Size size) {
    if (_modoDuelo && !_modoClasico) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _botonOponente(size, _selecOponente, "AMIGOS",Icons.people_outline_rounded,() async{
                setState(() {
                  _animationController.reset();
                  _selecOponente = true;
                });
                modal.mainBottomSheet(context, preguntas);
              },),
              SizedBox(height: size.height * 0.1,),
              _botonOponente(size, _selecAlAzar, "AL AZAR",Icons.loop, () {
                setState(() {
                  _selecOponente = false;
                  showDialog(context: context, builder:(_)=> _initMatchButton(context));
                  _animationController.reset();
                  _animationController.forward();
                  _selecAlAzar = true;
                });
              }),
            ],
          ),
        ]
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

  Widget _botonOponente(Size size, bool modo, String title, IconData icon, Function onTap){
    return Container(
      decoration: BoxDecoration(
        color: (modo) ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0)
      ),
      width: size.width*0.5,
      child: ListTile(
        leading: Icon(icon),
        title: AutoSizeText(title,maxLines: 1, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        onTap: onTap,
      ),
    );}

}


