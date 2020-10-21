import 'package:flutter/material.dart';

class BotonWidget extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget text;
  final Color colorPrimario;
  final Function onTap;
  final double width;
  BotonWidget({this.leading, this.text, this.colorPrimario, this.trailing, this.onTap, this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white.withOpacity(0.5),
      onTap: onTap,
      child: Container(
        width: width,
        color: (colorPrimario != null)?colorPrimario: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (leading != null)? leading : Container(),
            (text != null)? text : Container(),
            (trailing != null)? trailing : Container() 
          ],
        ),
      ),
    );
  }
}