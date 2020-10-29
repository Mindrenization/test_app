import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/models/task_step.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';

// Страница конкретной задачи
class TaskPage extends StatefulWidget {
  final VoidCallback onCheck;
  TaskPage(this.onCheck);
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController _controller = TextEditingController();
  bool isText = false;

  @override
  Widget build(BuildContext context) {
    final Task task = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorThemeDialog.mainColor,
        title: Text(
          task.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.line_style,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 15,
                      ),
                      Text(
                        'Редактировать',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 15,
                      ),
                      Text(
                        'Удалить',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorThemeDialog.backgroundColor,
        child: task.steps.isEmpty
            ? _addStepButton(task)
            : Column(
                children: [
                  if (task.steps.isNotEmpty)
                    for (int index = 0; index < task.steps.length; index++)
                      _stepTile(task, index),
                  _addStepButton(task),
                ],
              ),
      ),
    );
  }

  Widget _addStepButton(task) {
    if (!isText) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isText = true;
          });
        },
        child: Row(
          children: [
            Icon(Icons.add),
            Container(
              width: 10,
            ),
            Text('Добавить шаг')
          ],
        ),
      );
    } else if (isText) {
      return TextField(
        controller: _controller,
        onEditingComplete: () {
          setState(() {
            var lastStepId = task.steps.isEmpty ? 0 : task.steps.last.id;
            task.steps.add(TaskStep(++lastStepId, _controller.text, false));
            task.maxSteps++;
            _controller.text = '';
          });
        },
      );
    }
  }

  Widget _stepTile(task, index) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Checkbox(
            value: task.steps[index].isComplete,
            activeColor: const Color(0xFF6202EE),
            onChanged: (value) {
              widget.onCheck();
              setState(() {
                task.steps[index].isComplete = value;
                value ? task.currentStep++ : task.currentStep--;
              });
            },
          ),
          Text(task.steps[index].title),
          Spacer(),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  widget.onCheck();
                  task.maxSteps--;
                  task.steps[index].isComplete ? task.currentStep-- : null;
                  task.steps.removeAt(index);
                  task.steps.isEmpty ? isText = false : null;
                });
              })
        ],
      ),
    );
  }
}
