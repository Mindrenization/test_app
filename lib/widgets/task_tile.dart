import 'package:flutter/material.dart';
import 'package:test_app/pages/task_page.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';

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
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskPage(
                widget.task,
                onCheck: () {
                  setState(() {});
                },
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
                    color: ColorThemeDialog.mainColor,
                  ),
                  onPressed: widget.onDelete,
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
