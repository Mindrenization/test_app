import 'package:flutter/material.dart';
import 'package:test_app/resources/resources.dart';
import 'package:flutter_svg/svg.dart';

// Заглушка для пустой страницы задач
class NoTasksBackground extends StatefulWidget {
  final bool isFiltered;
  NoTasksBackground(
    this.isFiltered,
  );
  @override
  _NoTasksBackgroundState createState() => _NoTasksBackgroundState();
}

class _NoTasksBackgroundState extends State<NoTasksBackground> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = Tween(begin: -200.0, end: 0.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            widget.isFiltered
                ? Padding(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      'Фильтр: скрыть завершенные задачи',
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                  )
                : Container(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SvgPicture.asset(Resources.emptyTasksBackground),
                      Positioned(
                        bottom: _animation.value,
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
                      widget.isFiltered ? 'У вас нет невыполненных задач' : 'На данный момент в этой ветке нет задач',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
