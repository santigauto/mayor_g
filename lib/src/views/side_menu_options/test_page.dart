//ESTA PAGINA MOSTRARA LA PREGUNTA, EL TIMER, LA IMAGEN (OPCIONAL) Y LAS OPCIONES DE RESPUESTAS

import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:mayor_g/src/models/background_music.dart';

//MODELOS
import 'package:mayor_g/src/models/question_model.dart';

//WIDGETS PERSONALIZADOS
import 'package:mayor_g/src/widgets/custom_widgets.dart';

class TestPage extends StatefulWidget {
  final ListaPreguntasNuevas questions;
  final int n;
  TestPage({this.n, this.questions});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with TickerProviderStateMixin {

//          ---------------        DECLARO VARIABLES UTILES DE LA PAGINA           ------------------

  final player = BackgroundMusic.backgroundAssetsAudioPlayer;
  AnimationController controller; // CONTROLADOR DEL TEMPORIZADOR
  bool aux = false; // BANDERA DEL CONTROLADOR QUE ME PERMITE GENERAR UN POP EXTRA EN EL CASO DE QUE UN ALERTA NO SE CIERRE CUANDO SE ACABE EL TIEMPO
  ImageProvider imagen; // CONTENDRÁ LA IMAGEN DE LA PREGUNTA
  String imagenString; // ES EL STRING QUE LLAMARA EL NETWORK IMAGE
  ListaPreguntasNuevas questions; //LISTA DE PREGUNTAS (CON RESPUESTAS)
  int n; //INDICE DE LA PRENGUNTA DENTRO DE LA LISTA
  bool rush = false;
  bool flag = false;
  int tipo;
  int segundos;
  Animation hurryUp;

  StreamController<Object> _controller = new StreamController.broadcast();

  Stream<Object> get streamQ => _controller.stream;
  Function get sinkQ => _controller.sink.add;

  void disposeController() { 
    _controller.close();
  }

//           --------      EL INIT STATE SE ENCARGA DE ARRANCAR EL TEMPORIZADOR        ----------

  @override
  void initState() {

    //DEFINO LOS PARAMETROS QUE LLEGAN DE LA PAGINA ANTERIOR
    questions = widget.questions;
    n = widget.n;

    //DEFINO EL TIPO DE PREGUNTA
    tipo = questions.preguntas[n].getTipoPregunta();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: questions.preguntas[n].getDuration()),
    );
    hurryUp = Tween(begin: 50.0, end: 150.0).animate(CurvedAnimation(parent: controller, curve: Interval(0.2, 0.4, curve: Curves.easeInOut)));
    controller.addListener(() {
      if(controller.value < 0.25 && flag == false){ //SI SE ESTA ACABANDO EL TIEMPO, SE LEVANTARA EL FLAG PARA APURAR AL JUGADOR
          flag = true;
          sinkQ(flag);
      }
      if (controller.value == 0)
        {
        if (aux == true) {
          Navigator.pop(context);
        }
        Navigator.pushReplacementNamed(context, 'result',arguments: {'n': n, 'questions': questions, 'resultado': false});}
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//--------------------------------------------------------        BUILD          -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //DECLARACION DE VARIABLES

    final size = MediaQuery.of(context).size; //SIZES DEL CANVAS

    //SI LA IMAGEN EXISTE, LA BUSCARÁ
    if (questions.preguntas[n].imagen != null ||
        questions.preguntas[n].imagen != 'null' ||
        questions.preguntas[n].imagen != '') {
      imagenString = '${questions.preguntas[n].imagen}';
      if (imagenString.length < 2) {
        imagenString = '';
      }
      imagenString = imagenString.replaceFirst('data:image/jpeg;base64,', '');
      imagen = MemoryImage(
        base64Decode(imagenString),
      );
    }

    //COMIENZO DE LA CUENTA REGRESIVA
    controller.reverse(
      from: controller.value == 0 ? 1 : controller.value,
    );

    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            HeaderCurvo(),
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
                Answers(
                  tipo: tipo,
                  questions: questions,
                  n: n,
                )
              ],
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, _ ) {
                return Positioned(
                  left: -hurryUp.value,
                  top: -hurryUp.value,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Image(image:AssetImage('assets/MayorGAnimaciones/MayorG-apurando.gif')))
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _pregunta(Size size) {
    double d;
    if (imagenString == '' || imagenString == null || imagenString == 'null')
      d = 0.25;
    else
      d = 0.4;
    return Container(
      height: size.height * d,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            (questions.preguntas[n].unirConFlechas)? Column(
              children: [
                AutoSizeText('Arrastrar cada opcion de la primera columna con la correspondiente de la segunda', textAlign: TextAlign.center,),
                Divider(height: 1,)
              ],
            ):Container(),
            Center(
              child: AutoSizeText(
                 questions.preguntas[n].pregunta,
                maxLines: (questions.preguntas[n].imagenPregunta)? 2:7,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
            _foto(size)
          ],
        )),
      ),
    );
  }

  Widget _foto(Size size) {
    if (imagenString == '' || imagenString == null || imagenString == 'null') {
      return Container();
    } else {
      return Column(
        children: [
          Divider(color: Colors.black.withOpacity(0.7),),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: size.height * 0.25,
              child: Image(image: imagen,),
            ),
          ),
        ],
      );
    }
  }

  //      ---------       FUNCION QUE DISPARA ALERTA EN CASO DE QUE SE PRESIONE EL BOTON 'ATRAS' DEL DISPOSITIVO     ---------

  Future<bool> _back() {
    aux = true;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Quieres salir de la partida?',textAlign: TextAlign.center,),
        content: Text('¡Perderas los puntos de esta pregunta!',textAlign: TextAlign.left,),
        actions: <Widget>[
          TextButton(
              onPressed: () async{
                Navigator.pop(context, true);
                player.open(Audio('assets/audios/Background_Music.mp3'));player.loop = true; player.play();
                aux = false;
              },
              child: Text('Salir')),
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                aux = false;
              },
              child: Text('Cancelar'))
        ],
      ));
  }
}
