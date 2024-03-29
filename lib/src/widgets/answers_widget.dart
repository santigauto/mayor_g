import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/models/question_model.dart';



class Answers extends StatefulWidget {

  final int tipo;
  final int n;
  final ListaPreguntasNuevas questions;
  final AnimationController controller;
  const Answers({Key key,this.tipo,this.questions,this.n, this.controller}) : super(key: key);

  @override
  _AnswersState createState() => _AnswersState();
}


class _AnswersState extends State<Answers> with SingleTickerProviderStateMixin{

Map choices = {};

final Map<String,bool> score = {};
PreguntaNueva paquete;
PreferenciasUsuario prefs = new PreferenciasUsuario();

AnimationController controller;

Animation<double> fading1;
Animation<double> fading2;
Animation<double> fading3;
Animation<double> fading4;
List<Animation> listaFading;

Animation<double> moving1;
Animation<double> moving2;
Animation<double> moving3;
Animation<double> moving4;
List<Animation> listaMoving;

@override
  void initState() {
    prefs.score = 0;
    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

    moving1 = Tween(begin:50.0, end: 0.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.0, 0.25)));
    moving2 = Tween(begin:50.0, end: 0.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.25, 0.5)));
    moving3 = Tween(begin:50.0, end: 0.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.5, 0.75)));
    moving4 = Tween(begin:50.0, end: 0.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.75, 1.0)));

    fading1 = Tween(begin:0.0, end: 1.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.0, 0.25)));
    fading2 = Tween(begin:0.0, end: 1.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.25, 0.5)));
    fading3 = Tween(begin:0.0, end: 1.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.5, 0.75)));
    fading4 = Tween(begin:0.0, end: 1.0).animate(CurvedAnimation(parent:controller,curve:Interval(0.75, 1.0)));

    listaMoving = [moving1, moving2, moving3, moving4];
    listaFading = [fading1, fading2, fading3, fading4];

    paquete = widget.questions.preguntas[widget.n];

    if(paquete.imagenRespuesta == true){
      for (var i = 0; i < paquete.respuestas.length; i++) {
        paquete.respuestas[i] = paquete.respuestas[i].replaceFirst('data:image/jpeg;base64,', '');
      }
    }
    super.initState();
  }


@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _addAuxiliarReferences(aux){
    for (var i = 0;
          i < paquete.respuestas.length;
          i++) {
        aux.add({
          'respuesta': '${paquete.respuestas[i]}',
          'id': i
        });
      }
  }

  @override
  Widget build(BuildContext context) {

  final size = MediaQuery.of(context).size;
  List<dynamic> aux = [];
  
  _addAuxiliarReferences(aux);

    switch (widget.tipo) {
      case 0:
        return _answerType1(size,aux);
        break;
      case 1:
        return _answerType2(size,aux);
        break;
      case 2:
        return _answerType3(size,aux);
        break;  
      default: return _answerType4(size,widget.n);
    }
  }



//--------------------------------------- MULTIPLE CHOICE ( CLASICO ) -----------------------------------------------


Widget _answerType1(Size size, aux){
  controller.forward();
  return Expanded(
    child:  AnimatedBuilder(
      animation: controller,
      builder: (context,_){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _respuestas(size, aux),
          ),
        );
      },
    ) );
}

List<Widget> _respuestas(Size size, aux) {
    final List<Widget> answers = [];
    for (var i = 0; i < aux.length; i++) {
      int tag = (aux[i]['id'] * (widget.n+1)) + widget.n;
      answers.add(
        Transform.translate(
          offset: Offset(0, listaMoving[i].value),
          child: Opacity(
            opacity: listaFading[i].value,
            child: Hero(
              tag: tag,
              child: Container(
                width: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
                  ),
                  onPressed: () {
                    bool boolean;
                    if (aux[i]['id'] != paquete.respuestaCorrecta) {
                      boolean = false;
                    } else {boolean = true;}
                    Navigator.pushReplacementNamed(context, 'result', arguments: {'n': widget.n,'questions': widget.questions,'resultado': boolean});
                  },
                  child: Text(
                    aux[i]['respuesta'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
    answers.add(SizedBox(height: 10,));
  }

    return answers;
  }


//-------------------------------------------- MULTIPLE CHOICE ( 4 IMAGENES ) ---------------------------------------------

Widget _answerType2(Size size, aux){
  return Container(
    height: size.height*0.55,
    child: Table(
      children: _rows(size,aux)
    ),
  );
}

List<TableRow> _rows(Size size, aux){
  List<TableRow> rows = [];
  for (var i = 0; i < paquete.respuestas.length/2; i++) {
    rows.add(TableRow(
      children: [
        _imagen(size,i*2, aux),
        _imagen(size, i*2+1, aux)
      ],
    ));
  }
  
  return rows;
}

Widget _imagen(Size size,int i, aux){

  return GestureDetector(
    onTap: () {
      bool boolean;
      if (aux[i]['id'] != paquete.respuestaCorrecta) {
        boolean = false;
      } else {boolean = true;}
      Navigator.pushReplacementNamed(context, 'result', arguments: {'n': widget.n,'questions': widget.questions,'resultado': boolean});
    },
    child: Hero(
      tag: (aux[i]['id'] * (widget.n+1)) + widget.n,
      child: Container(
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
                base64Decode(paquete.respuestas[i])
              )
            )
          ),
        ),
        height: size.width*0.45,
        width: size.width*0.45,
        ),
    ),
  );
}

//----------------------------------------------- VERDADERO Y FALSO -----------------------------------------------------------

Widget _answerType3(Size size, aux){
  controller.forward();
  return Expanded(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context,child){
        return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: _respuestasVoF(aux)
          ),
        );}
      ),
  );
}

List<Widget> _respuestasVoF(aux){
  List<Widget> lista = [];
  for(int i=0;i<paquete.respuestas.length;i++) {
    lista.add(Transform.translate(
      offset: (i == 0)? Offset(listaMoving[i].value,0): Offset(-(listaMoving[i].value),0),
      child: Opacity(
        opacity: listaFading[i].value,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color:(paquete.respuestas[i].toLowerCase() == 'verdadero')? Theme.of(context).primaryColor: Colors.red[400],
              borderRadius: BorderRadius.circular(25)
            ),
            child: ListTile(
              onTap: (){
                bool boolean;
                if (aux[i]['id'] != paquete.respuestaCorrecta) {
                  boolean = false;
                } else {boolean = true;}
                Navigator.pushReplacementNamed(context, 'result', arguments: {'n': widget.n,'questions': widget.questions,'resultado': boolean});
              },
              title: Text(paquete.respuestas[i], textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ),
    ));
  }
  return lista;
}

//-------------------------------------------------- UNIR CON FLECHAS -------------------------------------------------------------------------

Widget _answerType4(Size size, int n){

  choices = paquete.getMapChoices();

  return Expanded(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: choices.keys.map((e) {
            return Draggable<String>(
              data: e,
              child: _inicial(e, size, Colors.white),
              feedback: _inicial(e, size, Colors.white.withOpacity(0.5)),
              childWhenDragging: Container(width: size.width*0.4, height: size.height*0.1,),
            );
          }).toList()
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: choices.keys.map((e) {
            return _target('hola', size, e);
          }).toList()
          ..shuffle(Random(n))
        ),
      ],
    ),
  );

  

}

Widget _inicial(String text, Size size, Color color){
  return Material(
      child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: size.width*0.4,
        height: size.height*0.1,
        color: color,
        child: Center(
          child: Text(text, 
            style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.normal,
              fontSize: 15,
              decorationColor: Colors.white.withOpacity(0)
              ),
              textAlign: TextAlign.center,
            )
          ),
      )
    ),
  );
}
Widget _target(String text,Size size,dynamic e){
  return DragTarget<String>(
    builder: (BuildContext context, List<String> incoming, List rejected){
      if(score[e] == true){
        return Container(height: size.height*0.1,);
      } else if (score[e] == false){
        return Container(height: size.height*0.1,);
      } else {
        return _inicial(choices[e], size, Colors.amber);
      }
    },
    onAccept: (data){
      setState(() {

        if(data==e){
          score[e] = true;
          prefs.score = prefs.score + 1;
        }
        else score[e] = false;

        if(score.length == 4)Navigator.pushReplacementNamed(context, 'result',arguments: {'n': widget.n, 'questions': widget.questions, 'resultado': false});
      });
    },
  );
}



//---------------------------------------------------------------


}
