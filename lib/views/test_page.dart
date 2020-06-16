import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin{

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
                Container(
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
                ),
                Expanded(child: Container())
              ],
            ),
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