import 'package:flutter/material.dart';
import 'package:test_app/data/models/task.dart';

// Карточка задачи в списке
class TaskTile extends StatefulWidget {
  final Task task;
  final Color color;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onCheck;
  TaskTile({
    this.task,
    this.color,
    this.onDelete,
    this.onTap,
    this.onCheck,
  });

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        widget.onDelete();
      },
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(right: 24),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Checkbox(
                value: widget.task.isComplete,
                activeColor: widget.color,
                onChanged: (value) {
                  widget.onCheck();
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: TextStyle(fontSize: 18),
                    ),
                    widget.task.maxSteps == 0
                        ? Container()
                        : Text(
                            '${widget.task.completedSteps} из ${widget.task.maxSteps}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
