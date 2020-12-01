import 'package:flutter/material.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/presentation/widgets/circular_progress_bar.dart';

class BranchTile extends StatelessWidget {
  final List<Branch> branchList;
  final int index;
  final onTap;
  final onDelete;
  BranchTile(this.branchList, this.index, {this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset.fromDirection(1.5, 3),
              color: Colors.black26,
              spreadRadius: 0.1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularProgressBar(
                  branchList[index].tasks.length == 0
                      ? 0
                      : branchList[index].completedTasks /
                          branchList[index].tasks.length,
                  branchList[index].customColorTheme.mainColor,
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 90,
            ),
            Text(
              branchList[index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${branchList[index].tasks.length} задач(и)',
              maxLines: 1,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _sticker(
                  text: '${branchList[index].completedTasks} сделано',
                  color: branchList[index].customColorTheme.backgroundColor,
                  textColor: branchList[index].customColorTheme.mainColor,
                  context: context,
                ),
                _sticker(
                  text: '${branchList[index].uncompletedTasks} осталось',
                  color: Colors.red[100],
                  textColor: Colors.red,
                  context: context,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _sticker(
      {String text, Color color, Color textColor, BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width / 5.6,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: textColor,
              fontSize: MediaQuery.of(context).size.width / 37),
        ),
      ),
    );
  }
}
