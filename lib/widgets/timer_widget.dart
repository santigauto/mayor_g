import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/pulse_animator.dart';

class TimerWidget extends StatefulWidget {
  final AnimationController controller;
  TimerWidget({Key key,@required this.controller}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>{

String get timerString{
    Duration duration = widget.controller.duration * widget.controller.value;
    //print(widget.controller.value);
    return '${(duration.inSeconds %60)}"';
  }  

  @override 
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.topCenter,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: PulseAnimatorWidget(
          begin: 0.5,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: widget.controller, 
                  builder:(BuildContext context, Widget child){
                    return CustomPaint(
                      painter: TimerPainter(
                        color: ((widget.controller.duration * widget.controller.value).inSeconds <= 3)?Colors.red:Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        animation: widget.controller
                        )
                    );
                  }),
              ),
              Align(
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: widget.controller, 
                      builder: (BuildContext context,Widget child){
                        return Text(
                          timerString, style: Theme.of(context).textTheme.headline4.copyWith(color:((widget.controller.duration * widget.controller.value).inSeconds <= 3)?Colors.red:Colors.white,),);
                      })
                  ],
                ),
              )
            ],
          ),
        ),
        ),
    );
  }

}

class TimerPainter extends CustomPainter{
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color, backgroundColor;

  @override
  void paint(Canvas canvas, Size size){
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint paintArco = Paint()
      ..color = backgroundColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width /2.0 , paint);
    paintArco.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi*1.5, progress, false, paintArco);

  }

  @override
  bool shouldRepaint(TimerPainter old){
    return animation.value != old.animation.value || color != old.color || backgroundColor != old.backgroundColor;
  }

}

