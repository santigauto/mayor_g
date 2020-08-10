//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES

import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/widgets/answers_widget.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/custom_header_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

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
  ListaPreguntas questions;       //LISTA DE PREGUNTAS (CON RESPUESTAS)
  int n;                          //INDICE DE LA PRENGUNTA DENTRO DE LA LISTA

//-------- EL INIT STATE SE ENCARGA DE ARRANCAR EL TEMPORIZADOR ----------

  @override
  void initState() {
    
    super.initState();
    
    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 15),
      );
    
  }

//-------------------------------------        BUILD          -----------------------------------------------
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final Map mapa = ModalRoute.of(context).settings.arguments;
    
    questions = mapa['questions'];
    n= mapa['n'];

    imagenString = '${questions.preguntas[n].pregunta.foto}';

    if(imagenString != null && imagenString != 'null' && imagenString != ''){
      imagenString = 'http://www.maderosolutions.com.ar/MayorG1/img/$imagenString';
      imagen = NetworkImage(imagenString);
      print(imagenString);
    }  //SI LA IMAGEN EXISTE, LA BUSCARÁ EN LA URL DE MADERO SOLUTIONS
      
    controller.reverse(
      from: controller.value == 0 ? 1 : controller.value,
    );
    controller.addStatusListener((state) {
      if (aux == true) {
        Navigator.pop(context);
      }
      return Navigator.pushReplacementNamed(context, 'result',arguments: {'n': n,'questions': questions,'resultado': false});
    });

    

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
                Answers(tipo: 4, questions: questions, n: n,)
              ],
            )
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
                    questions.preguntas[n].pregunta.pregunta,
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


  @override
  void dispose() {
    controller.dispose();
    //preguntasController.dispose();
    super.dispose();
  }
}
