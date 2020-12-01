import 'package:flutter/material.dart';

class CircularProgressBar extends StatefulWidget {
  final double value;
  final Color color;
  CircularProgressBar(this.value, this.color);
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

    return Container(
      width: 50,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: CustomPaint(
        child: Text(
          '${(value * 100).toInt()}%',
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.color,
            fontSize: 14,
          ),
        ),
        foregroundPainter: CircularPainter(value, widget.color),
      ),
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
  final Color color;
  CircularPainter(this.value, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = 26;

    final foregroundPaint = Paint()
      ..color = value == 0.0 ? Colors.grey[400] : color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = Colors.grey[400]
      ..strokeWidth = 4
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
