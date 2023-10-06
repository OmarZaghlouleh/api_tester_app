import 'dart:math';

import 'package:flutter/material.dart';

class _ArcPainter extends CustomPainter {
  _ArcPainter();

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    Path path = Path()..arcTo(rect, 0.0, pi / 10, true);
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke);

    canvas.drawArc(
        rect,
        0.0,
        pi / 2,
        false,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke);
  }
}

class ArcWidget extends StatelessWidget {
  const ArcWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: CustomPaint(
        painter: _ArcPainter(),
      ),
    );
  }
}
