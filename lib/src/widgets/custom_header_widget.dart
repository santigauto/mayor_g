
import 'package:flutter/material.dart';


class HeaderCurvo extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderCurvoPainter(context, color:Color(0xFF5C8D60)),
      ),
    );
  }
}

class _HeaderCurvoPainter extends CustomPainter {
  final Color color;
  _HeaderCurvoPainter(BuildContext context, {this.color});
  @override
  void paint(Canvas canvas, Size size) {
    
    final lapiz1 = new Paint();

    // Propiedades
    lapiz1.color = color;
    lapiz1.style = PaintingStyle.fill; // .fill .stroke
    lapiz1.strokeWidth = 1;

    final path1 = new Path();

    final lapiz2 = new Paint();

    // Propiedades
    lapiz2.color = Colors.black.withOpacity(0.2);
    lapiz2.style = PaintingStyle.fill; // .fill .stroke
    lapiz2.strokeWidth = 1;

    final path2 = new Path();

    // Dibujar con el path y el lapiz
    path2.lineTo( 0, size.height * 0.18 );
    path2.quadraticBezierTo(size.width * 0.5, -size.height * 0.17 + 50, size.width, size.height * 0.18 );
    path2.lineTo( size.width, 0 );

    canvas.drawPath(path2, lapiz2 );

    path1.lineTo( 0, size.height * 0.17 );
    path1.quadraticBezierTo(size.width * 0.5, -size.height * 0.17 + 50, size.width, size.height * 0.17 );
    path1.lineTo( size.width, 0 );

    canvas.drawPath(path1, lapiz1 );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}