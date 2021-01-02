import 'package:flutter/material.dart';

class TriangleShape extends CustomPainter {
  final Color color;
  final bool ltr;
  Paint painter;

  TriangleShape(this.color, this.ltr) {
    painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(ltr ? 0 : size.width, size.height);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
