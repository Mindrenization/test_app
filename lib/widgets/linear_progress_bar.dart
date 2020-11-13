import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinearProgressBar extends StatefulWidget {
  final double value;

  LinearProgressBar(this.value);

  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController controller;
  double value = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant LinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      controller
        ..value = 0
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: 0.0, end: widget.value).animate(controller)
      ..addListener(() {
        setState(() {
          value = _animation.value;
        });
      });
    return Container(
      height: 10,
      width: 150,
      child: CustomPaint(
        foregroundPainter: LinearPainter(value),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      ..color = value == 0.0 ? Colors.white : const Color(0xFF01A39D)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final edgePaint = Paint()
      ..color = const Color(0xFF01A39D)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, edgePaint);
    canvas.drawLine(start, end, backgroundPaint);
    if (value != 0) {
      canvas.drawLine(start, endProgressLine, foregroundPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as LinearPainter);
    return oldPainter.value != this.value;
  }
}
