import 'dart:ui';

import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  Rect rect;
  Color color;
  double scale;

  ShapePainter(this.rect, {this.color = Colors.teal, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addRect(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}