import 'package:flutter/material.dart';

class ClockFrames extends CustomPainter {
  final double progressValue;
  final LinearGradient progressBarColor;
  final Color hintColor;

  ClockFrames({
    required this.progressValue,
    required this.progressBarColor,
    required this.hintColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final double framesSize;
    if (size.width <= size.height) {
      framesSize = size.width;
    } else {
      framesSize = size.height;
    }

    const double Pi = 3.1416;
    final paint = Paint()
      ..strokeWidth = 15
      ..color = hintColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final startPath = Offset(size.width * 1 / 6, framesSize * 1 / 6);
    final endPath = Offset(size.width * 5 / 6, framesSize * 5 / 6);
    final rect = Rect.fromPoints(startPath, endPath);
    double circleStartValue = Pi - Pi * 1 / 5;
    double circleEndValue = Pi + Pi * 2 / 5;
    canvas.drawArc(rect, circleStartValue, circleEndValue, false, paint);
    final progressPaint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    progressPaint.shader = progressBarColor.createShader(rect);
    canvas.drawArc(rect, circleStartValue,
        (circleEndValue / 100) * progressValue, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
