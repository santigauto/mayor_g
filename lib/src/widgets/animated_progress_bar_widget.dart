import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double reachedValue;
  final double fullValue;
  final Widget title;
  final String caption;
  AnimatedProgressBar({@required this.reachedValue,@required this.fullValue, this.title, this.caption});
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                widget.title,
                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
                  value: progress.value,
                  semanticsLabel: widget.caption,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('${widget.reachedValue.toInt()}/${widget.fullValue.toInt()}', textAlign: TextAlign.end,style: TextStyle(color: Colors.white))
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