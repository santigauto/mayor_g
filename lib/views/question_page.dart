//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES

import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/views/result_page.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class QuestionPage extends StatefulWidget {
  final ListaPreguntas questions;
  const QuestionPage({Key key, this.questions}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin{

AnimationController controller;
bool aux = false;

String imagen = '';
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds:15),
      );
    controller.reverse(from: controller.value == 0 ? 1 : controller.value,);
    controller.addStatusListener((state){
      if (aux==true){Navigator.pop(context);}
      return Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => ResultPage(resultado:false))
      );});



  }

  Future<bool> _back(){
    aux=true;
  return showDialog(
    context: context,
    builder: (context)=>AlertDialog(
        title: Text('Quieres realmente salir de Mayor G'),
        actions: <Widget>[
          FlatButton(
            onPressed: (){Navigator.pop(context,true);aux=false;},
            child: Text('Salir')),
          FlatButton(
            onPressed: (){Navigator.pop(context,false);aux=false;}, 
            child: Text('Cancelar'))
        ],
      )
    );
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
                    height: size.height*0.12,
                    child: TimerWidget(controller: controller)),
                ),
                Container(height: (imagen == '') ? size.height*0.3 : size.height*0.15,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text(
                      'Pregunta',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),)),
                  ),
                ),
                _foto(size),
                Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 5),
                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _respuestas(),
                ),
                ))
              ],
            )
            
          ],
        ),
      ),
    );
  }

  Widget _foto(Size size){
    if(imagen == '' || imagen == null){
      return Container();
    }else 
      return Container(
       height:  size.height*0.25,
       decoration: BoxDecoration(
         image: DecorationImage(image: AssetImage(imagen)),
         shape: BoxShape.rectangle
       ),
     );
  }

  List<Widget> _respuestas(){
    final List<Widget> answers = [];
    List<Map<String,dynamic>> aux = [];

    widget.questions.preguntas[0].respuestas.forEach((f){
      var i = 0;
      aux.add({'respuesta' : f });
      aux.add({'id' : i });
      i++;
    });


    for (var i = 0; i < aux.length; i++) {
      answers.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor,width: 5)
          ),
          child: ListTile(
            onTap: (){
              MaterialPageRoute route;
              if(aux[i]['id'] != widget.questions.preguntas[0].respuestaCorrecta){
                route = MaterialPageRoute(builder: (context) => ResultPage(resultado:false));
                Navigator.pushReplacement(context, route);
              }else{
                route = MaterialPageRoute(builder: (context) => ResultPage(resultado:true));
                Navigator.pushReplacement(context, route);
              }
              },
            title: Text(aux[i]['respuesta'],textAlign: TextAlign.center,style: TextStyle(fontSize: 13),),),
        ));
    }

    return answers;
  }

   @override            
      void dispose() {
        controller.dispose();            
        super.dispose();            
      }
}