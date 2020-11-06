import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinearProgressBar extends StatelessWidget {
  final double value;

  LinearProgressBar(this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 150,
      child: CustomPaint(
        foregroundPainter: LinearPainter(this.value),
      ),
    );
  }
}

class LinearPainter extends CustomPainter {
  final double value;
  LinearPainter(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(0.0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    final endProgressLine = Offset(size.width * value, size.height / 2);

    final foregroundPaint = Paint()
      ..color = value == 0.0 ? Colors.white : Color(0xFF01A39D)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, backgroundPaint);
    canvas.drawLine(start, endProgressLine, foregroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as LinearPainter);
    return oldPainter.value != this.value;
  }
}
