import 'package:flutter/material.dart';

class CircularProgressBar extends StatefulWidget {
  final double value;
  CircularProgressBar(this.value);
  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
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
  void didUpdateWidget(covariant CircularProgressBar oldWidget) {
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
    return CustomPaint(
      child: Text(
        '${(value * 100).toInt()}%',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF01A39D),
        ),
      ),
      foregroundPainter: CircularPainter(value),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CircularPainter extends CustomPainter {
  final double value;
  CircularPainter(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = 28;

    final foregroundPaint = Paint()
      ..color = value == 0.0 ? Colors.grey[400] : const Color(0xFF01A39D)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = Colors.grey[400]
      ..strokeWidth = 6
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
