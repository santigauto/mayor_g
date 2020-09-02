//ESTA PAGINA MOSTRARA LA PREGUNTA, EL TIMER, LA IMAGEN (OPCIONAL) Y LAS OPCIONES DE RESPUESTAS

import 'dart:convert';
import 'package:flutter/material.dart';

//MODELOS
import 'package:mayor_g/src/models/question_model.dart';

//WIDGETS PERSONALIZADOS
import 'package:mayor_g/src/widgets/answers_widget.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/custom_header_widget.dart';
import 'package:mayor_g/src/widgets/timer_widget.dart';

class QuestionPage extends StatefulWidget {

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin {

//--------------- DECLARO VARIABLES UTILES DE LA PAGINA ------------------
  
  AnimationController controller; // CONTROLADOR DEL TEMPORIZADOR
  bool aux = false;               // BANDERA DEL CONTROLADOR QUE ME PERMITE GENERAR UN POP EXTRA EN EL CASO DE QUE UN ALERTA NO SE CIERRE CUANDO SE ACABE EL TIEMPO
  ImageProvider imagen;           // CONTENDRÁ LA IMAGEN DE LA PREGUNTA
  String imagenString;            // ES EL STRING QUE LLAMARA EL NETWORK IMAGE
  ListaPreguntasNuevas questions; //LISTA DE PREGUNTAS (CON RESPUESTAS)
  int n;                          //INDICE DE LA PRENGUNTA DENTRO DE LA LISTA
  bool rush = false;
  bool flag = true;
  int tipo;
  int segundos = 15;

//-------- EL INIT STATE SE ENCARGA DE ARRANCAR EL TEMPORIZADOR ----------

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: segundos),
      );
    
    
    controller.addListener((){
      if (aux == true) {
        Navigator.pop(context);
      }
      if(controller.value == 0)Navigator.pushReplacementNamed(
        context, 'result',arguments: {'n': n,'questions': questions,'resultado': false});
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
    final Map mapa = ModalRoute.of(context).settings.arguments; //ARGUMENTOS QUE RESIVE LA PAGINA 
    
    
    //DEFINO LOS PARAMETROS QUE LLEGAN DE LA PAGINA ANTERIOR
    questions = mapa['questions'];
    n= mapa['n'];

    /* switch (questions.preguntas[n].longitud) {
      case 1:
        segundos = 15;
        break;
      case 2:
        segundos = 20;
        break;
      default: segundos = 25;
    }  */
    //DEFINO EL TIPO DE PREGUNTA
    if(questions.preguntas[n].verdaderoFalso == true) tipo = 2;
    else if(questions.preguntas[n].unirConFlechas)tipo = 3;
    else if(questions.preguntas[n].imagenRespuesta)tipo = 1;
    else tipo = 0;

    //SI LA IMAGEN EXISTE, LA BUSCARÁ
    if(questions.preguntas[n].imagen != null || questions.preguntas[n].imagen != 'null' || questions.preguntas[n].imagen != ''){
      imagenString = '${questions.preguntas[n].imagen}';
      imagenString = imagenString.replaceFirst('data:image/jpeg;base64,', '');
      if(imagenString.length < 2){imagenString = '';}
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
                Answers(tipo: tipo, questions: questions, n: n,)
              ],
            ),
            (rush)?Image.asset('assets/MayorGAnimaciones/MayorG-apurando.gif'):Container()
          ],
        ),
      ),
    );
  }

  
  Widget _pregunta(Size size){

    double d;
    if(imagenString == '' || imagenString == null || imagenString == 'null')d = 0.25;
    else d = 0.4;
    return Container(
      height:size.height*d,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    questions.preguntas[n].pregunta,
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
    } else{
      return Container(
        height: size.height * 0.3,
        child: FadeInImage(placeholder: AssetImage('assets/MayorGAnimaciones/Canon_animado.gif'), image: imagen),
      );
      }
  }

  //--------- FUNCION QUE DISPARA ALERTA EN CASO DE QUE SE PRESIONE EL BOTON 'ATRAS' DEL DISPOSITIVO  ---------

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


  
}
