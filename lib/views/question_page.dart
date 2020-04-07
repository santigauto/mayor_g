//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES

import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin{

AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds:20)
      );
    controller.reverse(from: controller.value == 0 ? 1 : controller.value);
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question Page'),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: size.height*0.12,
                    child: TimerWidget(controller: controller)),
                ),
                Container(height: size.height*0.15,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text(
                      'Pregunta pregunta pregunta pregunta Pregunta pregunta pregunta pregunta Pregunta pregunta pregunta pregunta pregunta pregunta pregunta pregunta',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),)),
                  ),
                ),
                Container(height: size.height*0.28,width: size.width,
                  child: Card(
                    color: Colors.black.withOpacity(0.5),
                    child: Text('data'),
                  )
                ),
                Expanded(child: Container(color: Colors.blue.withOpacity(0.5), 
                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ListTile(title: Text('Respuesta 1',textAlign: TextAlign.center,),),
                    ListTile(title: Text('Respuesta 2',textAlign: TextAlign.center,),),
                    ListTile(title: Text('Respuesta 3',textAlign: TextAlign.center,),),
                    ListTile(title: Text('Respuesta 4',textAlign: TextAlign.center,),)
                  ],
                ),
                ))
              ],
            )
            
          ],
        ),
      ),
    );
  }
}