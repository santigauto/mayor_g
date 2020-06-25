
import 'package:flutter/material.dart';


class HeaderCurvo extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderCurvoShadowPainter(context, color:Color(0xFF5C8D60)),
      ),
    );
  }
}

class _HeaderCurvoPainter extends CustomPainter {
  final Color color;
  _HeaderCurvoPainter(BuildContext context, {this.color});
  @override
  void paint(Canvas canvas, Size size) {
    
    final lapiz = new Paint();

    // Propiedades
    lapiz.color = color;
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 1;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.lineTo( 0, size.height * 0.12 );
    path.quadraticBezierTo(size.width * 0.5, -size.height * 0.045, size.width, size.height * 0.12 );
    path.lineTo( size.width, 0 );

    canvas.drawPath(path, lapiz );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  

}
class _HeaderCurvoShadowPainter extends CustomPainter {
  final Color color;
  _HeaderCurvoShadowPainter(BuildContext context, {this.color});
  @override
  void paint(Canvas canvas, Size size) {
    
    final lapiz = new Paint();

    // Propiedades
    lapiz.color = color;
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 1;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.lineTo( 0, size.height * 0.14 );
    path.quadraticBezierTo(size.width * 0.5, -size.height * 0.14 + 50, size.width, size.height * 0.14 );
    path.lineTo( size.width, 0 );

    canvas.drawPath(path, lapiz );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}