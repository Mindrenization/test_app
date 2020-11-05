import 'package:flutter/material.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/change_task_name_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/widgets/delete_task_dialog.dart';
import 'package:test_app/widgets/popup_button.dart';
import 'package:test_app/widgets/step_list.dart';

// Страница детализации задачи
class TaskPage extends StatefulWidget {
  final Task task;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;
  TaskPage({this.task, this.onRefresh, this.onDelete});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorThemeDialog.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorThemeDialog.mainColor,
        title: Text(
          widget.task.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: PopupButton(
                text: 'Редактировать',
                icon: Icons.line_style,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeTaskTitleDialog(
                          task: widget.task,
                          onRefresh: () {
                            setState(() {});
                            widget.onRefresh();
                          },
                        );
                      });
                },
              )),
              PopupMenuItem(
                  child: PopupButton(
                text: 'Удалить',
                icon: Icons.delete,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteTaskDialog(
                          task: widget.task,
                          onDelete: () {
                            widget.onDelete();
                            Navigator.pop(context);
                          },
                        );
                      });
                },
              )),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: _topButton(),
            ),
            StepList(
              widget.task,
              onRefresh: () {
                widget.onRefresh();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _topButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.task.isComplete) {
            widget.task.isComplete = false;
          } else {
            widget.task.isComplete = true;
          }
        });
        widget.onRefresh();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.cyan[600],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  spreadRadius: 1,
                  blurRadius: 3,
                  color: Colors.black38)
            ]),
        child: Icon(
          widget.task.isComplete ? Icons.close : Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
