import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/presentation/widgets/linear_progress_bar.dart';
import 'package:test_app/resources/resources.dart';

class HeaderCard extends StatelessWidget {
  final BranchLoaded state;
  HeaderCard(this.state);

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
          child: state.totalTasks != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Завершено ${state.totalCompletedTasks.toInt()} задач из ${state.totalTasks.toInt()}',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: LinearProgressBar(
                        state.totalCompletedTasks / state.totalTasks,
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
