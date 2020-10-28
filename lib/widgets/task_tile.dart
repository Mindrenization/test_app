import 'package:flutter/material.dart';
import '../pages/task_page.dart';

// Карточка задачи в списке
class TaskTile extends StatefulWidget {
  final task;
  final VoidCallback delete;
  TaskTile({this.task, this.delete});
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskPage(),
              settings: RouteSettings(
                arguments: widget.task,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                            '${widget.task.currentStep} из ${widget.task.maxSteps}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: const Color(0xFF6202EE),
                  ),
                  onPressed: widget.delete,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 5,
        )
      ],
    );
  }
}
