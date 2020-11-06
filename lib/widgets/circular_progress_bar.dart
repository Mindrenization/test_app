import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgressBar extends StatelessWidget {
  final double value;

  CircularProgressBar(this.value);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Text(
        '${(value * 100).toInt()}%',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF01A39D),
        ),
      ),
      foregroundPainter: CircularPainter(this.value),
    );
  }
}

class CircularPainter extends CustomPainter {
  final double value;
  CircularPainter(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = 26;

    final foregroundPaint = Paint()
      ..color = value == 0.0 ? Colors.grey[400] : const Color(0xFF01A39D)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = Colors.grey[400]
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);
    final start = 55.0;
    final end = (-6.28 * value);
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      start,
      end,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as CircularPainter);
    return oldPainter.value != this.value;
  }
}
