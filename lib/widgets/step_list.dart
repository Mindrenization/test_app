import 'package:intl/intl.dart';
import 'package:test_app/blocs/task_details_bloc.dart';
import 'package:test_app/models/task.dart';
import 'package:flutter/material.dart';

class StepList extends StatefulWidget {
  final Task task;
  final TaskDetailsBloc stepBloc;
  final snapshot;
  final VoidCallback onRefresh;
  StepList(
    this.task,
    this.stepBloc,
    this.snapshot, {
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
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Создано: ${DateFormat('dd.MM.yyyy').format(widget.task.createDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          for (int index = 0; index < widget.snapshot.steps.length; index++)
            _stepTile(widget.snapshot, widget.task, index, widget.stepBloc),
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
          widget.stepBloc.createStep(task, _stepController.text);
          _stepController.text = '';
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

  Widget _stepTile(snapshot, task, index, stepBloc) {
    return Row(
      children: [
        Checkbox(
          value: snapshot.steps[index].isComplete,
          activeColor: const Color(0xFF6202EE),
          onChanged: (value) {
            widget.onRefresh();
            widget.stepBloc.isComplete(task, index, value);
          },
        ),
        Expanded(
          child: Text(
            snapshot.steps[index].title,
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
              widget.stepBloc.deleteStep(task, index);
              widget.onRefresh();
            },
          ),
        ),
      ],
    );
  }
}
