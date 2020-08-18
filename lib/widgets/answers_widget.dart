
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';

class Answers extends StatefulWidget {
  final int tipo;
  final int n;
  final ListaPreguntas questions;
  final AnimationController controller;
  const Answers({Key key,this.tipo,this.questions,this.n, this.controller}) : super(key: key);

  @override
  _AnswersState createState() => _AnswersState();
}

class _AnswersState extends State<Answers> with SingleTickerProviderStateMixin{

final Map choices = {
  'A Habia una vez un circo que alegraba siempre el corazon': 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB': 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
  'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC': 'cccccccccccccccccccccccccccccccc',
  'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD': 'dddddddddddddddddddddddddddddddd'
};

final Map<String,bool> score = {};

AnimationController controller;

Animation<double> moving;
Animation<double> fading;

@override
  void initState() {

    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

    moving = Tween(begin:-50.0, end: 0.0).animate(controller);
    fading = Tween(begin:0.0, end: 1.0).animate(controller);

    super.initState();
  }


@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
    switch (widget.tipo) {
      case 0:
        return _answerType1(size);
        break;
      case 1:
        return _answerType2(size);
        break;
      case 2:
        return _answerType3(size);
        break;  
      default: return _answerType4(size);
    }
  }



//--------------------------------------- MULTIPLE CHOICE ( CLASICO ) -----------------------------------------------


Widget _answerType1(Size size){
  controller.forward();
  return Expanded(
    child:  AnimatedBuilder(
      animation: controller,
      builder: (context,child){
        return Transform.translate(
          offset: Offset(0, moving.value),
          child: Opacity(
            opacity: fading.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _respuestas(size),
              ),
            ),
          ),
        );
      },
    ) );
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
        Hero(
          tag: aux[i]['id'],
          child: Container(
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
    );
    answers.add(SizedBox(height: 10,));
  }

    return answers;
  }


//-------------------------------------------- MULTIPLE CHOICE ( 4 IMAGENES ) ---------------------------------------------

Widget _answerType2(Size size){
  return Container(
    height: size.height*0.55,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _imagen(Colors.pink, size,),
            _imagen(Colors.amber, size,),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _imagen(Colors.deepPurple, size,),
            _imagen(Colors.lightBlue, size,),
          ],
        ),
      ],
    ),
  );
}

Widget _imagen(Color color, Size size,){
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        width: 3,
        color: Theme.of(context).primaryColor
      ),
      color: color
    ),
    height: size.width*0.45,
    width: size.width*0.45,
    );
}

//----------------------------------------------- VERDADERO Y FALSO -----------------------------------------------------------

Widget _answerType3(Size size){
  return Expanded(
      child: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(25)
              ),
              child: ListTile(
                title: Text('VERDADERO', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(25)
              ),
              child: ListTile(
                title: Text('FALSO', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//-------------------------------------------------- UNIR CON FLECHAS -------------------------------------------------------------------------

Widget _answerType4(Size size){

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
            return _target('hola', size, score, e, choices);
          }).toList()
          ..shuffle(Random(1))
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
Widget _target(String text,Size size,dynamic score,dynamic e, dynamic choices){
  return DragTarget<String>(
    builder: (BuildContext context, List<String> incoming, List rejected){
      if(score[e] == true){
        return _inicial('correcto', size, Colors.green);
      } else if (score[e] == false){
        return _inicial('incorrecto', size, Colors.red);
      } else {
        return _inicial(choices[e], size, Colors.amber);
      }
    },
    onWillAccept: (data) => data == e, 
    onAccept: (data){
      setState(() {
        score[e] = true;
      });
    },
    onLeave: (data){
      setState(() {
        score[e] = false;
      });
    },
  );
}



//---------------------------------------------------------------


}

/* class _AnswerType4 extends StatefulWidget {
  @override
  __AnswerType4State createState() => __AnswerType4State();
}

final Map<String,bool> score = {};

  final Map choices = {
    'A Habia una vez un circo que alegraba siempre el corazon': 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB': 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
    'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC': 'cccccccccccccccccccccccccccccccc',
    'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD': 'dddddddddddddddddddddddddddddddd'
  }; // ESTO SE VA!


class __AnswerType4State extends State<_AnswerType4> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            return _target('hola', size, score, e, choices);
          }).toList()
          ..shuffle(Random(1))
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
Widget _target(String text,Size size,dynamic score,dynamic e, dynamic choices){
  return DragTarget<String>(
    builder: (BuildContext context, List<String> incoming, List rejected){
      if(score[e] == true){
        return _inicial('correcto', size, Colors.green);
      } else if (score[e] == false){
        return _inicial('incorrecto', size, Colors.red);
      } else {
        return _inicial(choices[e], size, Colors.amber);
      }
    },
    onWillAccept: (data) => data == e, 
    onAccept: (data){
      setState(() {
        score[e] = true;
      });
      print(score[e]);
    },
    onLeave: (data){
      setState(() {
        score[e] = false;
      });
      print(score[e]);
    },
  );
}
} */