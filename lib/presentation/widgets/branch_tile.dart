import 'package:flutter/material.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/presentation/widgets/circular_progress_bar.dart';

// Карточка ветки
class BranchTile extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  BranchTile(
    this.branch, {
    this.onTap,
    this.onDelete,
  });

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
                  branch.tasks.length == 0 ? 0 : branch.completedTasks / branch.tasks.length,
                  branch.mainColor,
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            Text(
              branch.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3, bottom: 4),
              child: Text(
                '${branch.tasks.length} задач(и)',
                maxLines: 1,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _sticker(
                  text: '${branch.completedTasks} сделано',
                  color: branch.backgroundColor,
                  textColor: branch.mainColor,
                  context: context,
                ),
                _sticker(
                  text: '${branch.uncompletedTasks} осталось',
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

  Widget _sticker({String text, Color color, Color textColor, BuildContext context}) {
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
          style: TextStyle(color: textColor, fontSize: MediaQuery.of(context).size.width / 37),
        ),
      ),
    );
  }
}
