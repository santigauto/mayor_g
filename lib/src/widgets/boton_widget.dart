import 'package:flutter/material.dart';

class BotonWidget extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget text;
  final Color colorPrimario;
  final Function onTap;
  BotonWidget({this.leading, this.text, this.colorPrimario, this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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