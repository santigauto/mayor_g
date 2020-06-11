//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES

import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/views/result_page.dart';
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

//--------------- DECLARO VARIABLES UTILES DE LA PAGINA ------------------


  AnimationController controller; // CONTROLADOR DEL TEMPORIZADOR
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
    }//SI LA IMAGEN EXISTE, LA BUSCARÁ EN LA URL DE MADERO SOLUTIONS

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
                SizedBox(height: 26,),
                Expanded(
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: _respuestas(size),
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

  List<Widget> _respuestas(Size size) {
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
      answers.add(
        Container(
          width: double.infinity,
          child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
            ),
            onPressed: () {
              bool boolean;
              if (aux[i]['id'] != widget.questions.preguntas[widget.n].respuestaCorrecta) {
                boolean = false;
              } else {boolean = true;}
              var route = MaterialPageRoute(builder: (context){return ResultPage(n: widget.n,questions: widget.questions,resultado: boolean,);});
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              aux[i]['respuesta'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
      answers.add(SizedBox(height: 6,));
      /* answers.add(Container(
        height: size.height*0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 5)),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          onTap: () {
            bool boolean;
            if (aux[i]['id'] != widget.questions.preguntas[widget.n].respuestaCorrecta) {
              boolean = false;
            } else {boolean = true;}
            var route = MaterialPageRoute(builder: (context){return ResultPage(n: widget.n,questions: widget.questions,resultado: boolean,);});
            Navigator.pushReplacement(context, route);
          },
          title: Text(
            aux[i]['respuesta'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      )); */
    }

    return answers;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
