import 'package:flutter/material.dart';

// Модальное окно для изменения названия задачи
class ChangeTaskTitleDialog extends StatefulWidget {
  final task;
  final onChange;
  ChangeTaskTitleDialog(this.task, {this.onChange});
  @override
  _ChangeTaskTitleDialogState createState() => _ChangeTaskTitleDialogState();
}

class _ChangeTaskTitleDialogState extends State<ChangeTaskTitleDialog> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Редактирование',
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
            controller: _titleController,
            decoration: InputDecoration(
                labelText: 'Введите новое название задачи',
                labelStyle: TextStyle(color: Colors.grey[700]),
                hintText: widget.task.title,
                isDense: true),
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
                'Выбрать',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // setState(() {
                //   widget.task.title = _titleController.text;
                // });
                widget.onChange(_titleController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
