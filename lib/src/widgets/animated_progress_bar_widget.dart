import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double reachedValue;
  final double fullValue;
  AnimatedProgressBar({this.reachedValue, this.fullValue});
  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation progress;

  @override
  void initState() {
    double percentage = widget.reachedValue / widget.fullValue;
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 2000));
    progress = new Tween(begin: 0.0, end: percentage).animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, snapshot) {
        _animationController.forward();
        return Card(
          color: Color(0xFF838547).withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 5.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Proximo Nivel: - BRONCE II -',textAlign: TextAlign.start,style: TextStyle(color: Colors.white),),
                  ],
                ),
            LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
              value: progress.value,
              semanticsLabel: 'Próximo Nivel',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('${widget.reachedValue.toInt()}/${widget.fullValue.toInt()} pts', textAlign: TextAlign.end,style: TextStyle(color: Colors.white))
              ],
            ),
              ],
            ),
          ),
        );
      }
    );
  }
}