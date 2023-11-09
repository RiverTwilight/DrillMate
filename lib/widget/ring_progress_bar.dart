import 'dart:math';
import 'package:flutter/material.dart';

class RectProgressBar extends StatelessWidget {
  final double progress;
  final double strokeWidth;

  RectProgressBar({required this.progress, required this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0, // Change this to adjust the size
      height: 30.0,
      child: CustomPaint(
        foregroundPainter: _RingPainter(
          progress: progress,
          progressColor: Theme.of(context).primaryColor,
          backgroundColor: Color(0xffD9D9D9),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.width - strokeWidth) / 2;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progress * 2 * pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) {
    return progress != old.progress ||
        progressColor != old.progressColor ||
        backgroundColor != old.backgroundColor ||
        strokeWidth != old.strokeWidth;
  }
}
