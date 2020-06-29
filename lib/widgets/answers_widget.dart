import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/views/result_page.dart';

class Answers extends StatefulWidget {
  final int tipo;
  final int n;
  final ListaPreguntas questions;
  const Answers({Key key,this.tipo,this.questions,this.n}) : super(key: key);

  @override
  _AnswersState createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {
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
      default: return _answerType3(size);
    }
  }



//---------------------------------------------------------------

Widget _answerType1(Size size){
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

//---------------------------------------------------------------


Widget _answerType2(Size size){
  return Expanded(
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _respuestas(size),
    ),
  ));
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
      answers.add(SizedBox(height: 10,));
    }

    return answers;
  }


//---------------------------------------------------------------

Widget _answerType3(Size size){
  return Container(
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
  );
}

//---------------------------------------------------------------


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

}
