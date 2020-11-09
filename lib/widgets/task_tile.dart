import 'package:flutter/material.dart';
import 'package:test_app/pages/task_details_page.dart';

// Карточка задачи в списке
class TaskTile extends StatefulWidget {
  final task;
  final VoidCallback onDelete;
  TaskTile({this.task, this.onDelete});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => widget.onDelete(),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(right: 25),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(
              task: widget.task,
              onRefresh: () {
                setState(() {});
              },
              onDelete: widget.onDelete,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Checkbox(
                value: widget.task.isComplete,
                activeColor: const Color(0xFF6202EE),
                onChanged: (value) {
                  setState(() => widget.task.isComplete = value);
                },
              ),
              Column(
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
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
