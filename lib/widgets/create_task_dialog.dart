import 'package:flutter/material.dart';
import 'package:test_app/models/task.dart';

// Модал создания задачи
class CreateTaskDialog extends StatefulWidget {
  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
  final List<Task> tasksList;
  final VoidCallback onRefresh;
  CreateTaskDialog({this.tasksList, this.onRefresh});
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Создать задачу',
        style: TextStyle(fontSize: 16),
      ),
      children: [
        Container(
          height: 10,
        ),
        Container(
          child: TextField(
            maxLength: 30,
            autofocus: true,
            onEditingComplete: () => _complete(),
            controller: _titleController,
            decoration: InputDecoration(
                hintText: 'Введите название задачи', isDense: true),
          ),
        ),
        Container(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: Text(
                'Отмена',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'Создать',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () => _complete(),
            ),
          ],
        ),
      ],
    );
  }

  _complete() {
    var lastTaskId = widget.tasksList.isEmpty ? 0 : widget.tasksList.last.id;
    setState(
      () => widget.tasksList
          .add(Task(++lastTaskId, _titleController.text, false, 0, 0, '')),
    );
    widget.onRefresh();
    Navigator.pop(context);
  }
}
