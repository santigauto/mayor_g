import 'package:flutter/material.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/widgets/answers_widget.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class PicsPage extends StatefulWidget {
  final ListaPreguntas questions;
  final int n;
  const PicsPage({Key key, this.n, this.questions}) : super(key: key);

  @override
  _PicsPageState createState() => _PicsPageState();
}

class _PicsPageState extends State<PicsPage> with TickerProviderStateMixin{

AnimationController controller;

@override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 15));
    controller.reverse(from: controller.value == 0 ? 1 : controller.value,);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SafeArea(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    height: size.height*0.12,
                    child: TimerWidget(controller: controller)
                    ),
                ),
                Expanded(child: Container()),
                _pregunta(size),
                Expanded(child: Container()),
                Answers(tipo: 1, questions: widget.questions, n: widget.n,)
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _pregunta(Size size){

    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta Pregunta',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
              ),
        ),
      ),
    );

  }
}