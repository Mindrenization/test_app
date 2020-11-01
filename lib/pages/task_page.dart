import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/models/task_step.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/widgets/popup_button.dart';

// Страница конкретной задачи
class TaskPage extends StatefulWidget {
  final Task task;
  final VoidCallback onCheck;
  TaskPage({this.task, this.onCheck});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController _stepController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isText = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
  }

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
                },
              )),
              PopupMenuItem(
                  child: PopupButton(
                text: 'Удалить',
                icon: Icons.delete,
                onTap: () {
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(20),
          color: Colors.white,
          elevation: 5,
          child: Column(
            children: [
              for (int index = 0; index < widget.task.steps.length; index++)
                _stepTile(widget.task, index),
              Padding(
                padding: EdgeInsets.all(10),
                child: _addStepButton(widget.task),
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                height: 1,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  onChanged: (text) {
                    setState(() {
                      widget.task.description = text;
                      print(widget.task.description);
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    labelText: 'Заметки по задаче...',
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stepController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            Icon(
              Icons.add,
              color: Colors.blue,
            ),
            Container(
              width: 10,
            ),
            Text(
              'Добавить шаг',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      );
    } else if (isText) {
      return TextField(
        autofocus: true,
        controller: _stepController,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          setState(() {
            var lastStepId = task.steps.isEmpty ? 0 : task.steps.last.id;
            task.steps.add(TaskStep(++lastStepId, _stepController.text, false));
            task.maxSteps++;
            _stepController.text = '';
          });
          widget.onCheck();
        },
      );
    }
  }

  Widget _stepTile(task, index) {
    return Row(
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
        Expanded(
          child: Text(
            task.steps[index].title,
            maxLines: 5,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey[700],
            ),
            onPressed: () {
              setState(() {
                widget.onCheck();
                task.maxSteps--;
                task.steps[index].isComplete ? task.currentStep-- : null;
                task.steps.removeAt(index);
                task.steps.isEmpty ? isText = false : null;
              });
            },
          ),
        ),
      ],
    );
  }
}
