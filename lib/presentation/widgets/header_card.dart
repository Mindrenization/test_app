import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/presentation/widgets/linear_progress_bar.dart';
import 'package:test_app/resources/resources.dart';

// Карточка для шапки главной страницы
class HeaderCard extends StatelessWidget {
  final double totalTasks;
  final double totalCompletedTasks;
  HeaderCard({
    this.totalTasks,
    this.totalCompletedTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Все задания',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: totalTasks != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Завершено ${totalCompletedTasks.toInt()} задач из ${totalTasks.toInt()}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: LinearProgressBar(
                        totalCompletedTasks / totalTasks,
                      ),
                    ),
                  ],
                )
              : Text(
                  'На данный момент\nзадачи отсутствуют',
                  style: TextStyle(fontSize: 16),
                ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SvgPicture.asset(
            Resources.mainLogo,
          ),
        ),
      ],
    );
  }
}
