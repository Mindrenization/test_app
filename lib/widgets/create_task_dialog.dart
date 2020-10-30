import 'package:flutter/material.dart';

// Модал создания задачи
class CreateTaskDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCreate;
  CreateTaskDialog({this.controller, this.onCreate});

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
            autofocus: true,
            controller: controller,
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
              onPressed: onCreate,
            ),
          ],
        ),
      ],
    );
  }
}
