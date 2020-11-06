import 'package:test_app/models/task_step.dart';
import 'package:test_app/models/task.dart';
import 'package:flutter/material.dart';

class StepList extends StatefulWidget {
  final Task task;
  final VoidCallback onRefresh;
  StepList(
    this.task, {
    this.onRefresh,
  });
  @override
  _StepListState createState() => _StepListState();
}

class _StepListState extends State<StepList> {
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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: _descriptionField(),
          ),
        ],
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
    } else {
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
          widget.onRefresh();
        },
      );
    }
  }

  Widget _descriptionField() {
    return TextField(
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
    );
  }

  Widget _stepTile(task, index) {
    return Row(
      children: [
        Checkbox(
          value: task.steps[index].isComplete,
          activeColor: const Color(0xFF6202EE),
          onChanged: (value) {
            widget.onRefresh();
            setState(() {
              task.steps[index].isComplete = value;
              value ? task.currentStep++ : task.currentStep--;
            });
          },
        ),
        Expanded(
          child: Text(
            task.steps[index].title,
            maxLines: null,
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
                widget.onRefresh();
                task.maxSteps--;
                if (task.steps[index].isComplete) {
                  task.currentStep--;
                }
                task.steps.removeAt(index);
                if (task.steps.isEmpty) {
                  isText = false;
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
