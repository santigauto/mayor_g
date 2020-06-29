//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES

import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/views/result_page.dart';
import 'package:mayor_g/widgets/answers_widget.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/custom_header_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class QuestionPage extends StatefulWidget {
  final ListaPreguntas questions;   //LISTA DE PREGUNTAS (CON RESPUESTAS)
  final int n;                      //INDICE DE LA PRENGUNTA DENTRO DE LA LISTA
  const QuestionPage({Key key, this.questions, this.n}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin {

//--------------- DECLARO VARIABLES UTILES DE LA PAGINA ------------------


  AnimationController controller; // CONTROLADOR DEL TEMPORIZADOR
  //AnimationController preguntasController; 
  bool aux = false;               // BANDERA DEL CONTROLADOR QUE ME PERMITE GENERAR UN POP EXTRA EN EL CASO DE QUE UN ALERTA NO SE CIERRE CUANDO SE ACABE EL TIEMPO
  ImageProvider imagen;           // CONTENDRÁ LA IMAGEN DE LA PREGUNTA
  String imagenString;            // ES EL STRING QUE LLAMARA EL NETWORK IMAGE

//-------- EL INIT STATE SE ENCARGA DE ARRANCAR EL TEMPORIZADOR ----------
  @override
  void initState() {
    super.initState();

    imagenString = '${widget.questions.preguntas[widget.n].pregunta.foto}';

    if(imagenString != null && imagenString != 'null' && imagenString != ''){
      imagenString = 'http://www.maderosolutions.com.ar/MayorG1/img/$imagenString';
      imagen = NetworkImage(imagenString);
      print(imagenString);
    }                                                                                //SI LA IMAGEN EXISTE, LA BUSCARÁ EN LA URL DE MADERO SOLUTIONS
    //preguntasController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    //preguntasController.forward();
    //if(preguntasController.status == AnimationStatus.completed){
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
        var route = MaterialPageRoute(builder: (context){return ResultPage(n: widget.n,questions: widget.questions,resultado: false,);});
        return Navigator.pushReplacement(context, route);
      });
    //}
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
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

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
                Expanded(child: Answers(tipo: 0, questions: widget.questions, n: widget.n,))
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
                    widget.questions.preguntas[widget.n].pregunta.pregunta,
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
        decoration: BoxDecoration(
            image: DecorationImage(image: imagen),
            shape: BoxShape.rectangle),
      );
      }
  }


  @override
  void dispose() {
    controller.dispose();
    //preguntasController.dispose();
    super.dispose();
  }
}
