import 'dart:ui';

import 'package:flutter/material.dart';

class PreviewPainter extends CustomPainter {
  int _nbPix = 5;
  Map<Offset, Color> colors;

  PreviewPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.keys.isNotEmpty) {
      print("PreviewPainter Painting !");
      Offset o1 = colors.keys.first;
      // print("PreviewPainter o1:[${o1.dx},${o1.dy}]");
      colors.forEach((o, c) {
        for (int i=0 ; i<_nbPix ; i++) {
          for (int j=0 ; j<_nbPix ; j++) {
            var offset = Offset(((o.dx-o1.dx)*_nbPix)+i, ((o.dy-o1.dy)*_nbPix)+j);
            canvas.drawPoints(PointMode.points, [offset],
                Paint()
                  ..color = c
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke
                  ..strokeCap = StrokeCap.round
            );
            // print("PreviewPainter draw:[$i,$j] o:[${o.dx},${o.dy}] off:[${offset.dx},${offset.dy}] c:[${c.red},${c.green},${c.blue}]");
          }
        }
      });
    } else {
      print("PreviewPainter Empty !");
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
