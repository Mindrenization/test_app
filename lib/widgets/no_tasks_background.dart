import 'package:flutter/material.dart';
import 'package:test_app/resources/resources.dart';
import 'package:flutter_svg/svg.dart';

class NoTasksBackground extends StatefulWidget {
  final isFiltered;
  NoTasksBackground(this.isFiltered);
  @override
  _NoTasksBackgroundState createState() => _NoTasksBackgroundState();
}

class _NoTasksBackgroundState extends State<NoTasksBackground>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController controller;
  var logoHight = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: -200.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          logoHight = _animation.value;
        });
      });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(Resources.emptyTasksBackground),
              ),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(Resources.emptyTasksSecondBackground),
              ),
              Positioned(
                right: 86,
                bottom: logoHight,
                child: SvgPicture.asset(Resources.emptyTasksLogo),
              ),
            ],
          ),
          Container(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 90),
            child: Text(
              widget.isFiltered
                  ? 'У вас нет невыполненных задач'
                  : 'На данный момент в этой ветке нет задач',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
