import 'package:flutter/material.dart';

class PulseAnimatorWidget extends StatefulWidget {

  final Widget child;
  final double begin;

  PulseAnimatorWidget({Key key,@required this.child, @required this.begin}) : super(key: key);

  @override
  _PulseAnimatorWidgetState createState() => _PulseAnimatorWidgetState();
}

class _PulseAnimatorWidgetState extends State<PulseAnimatorWidget> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation<double> fading;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _controller.reverse();
      }
      if(status == AnimationStatus.dismissed){
        _controller.forward();
      }
    });

    fading = Tween(begin: widget.begin, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: fading,
       child: widget.child,
    );
  }
}