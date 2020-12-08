import 'package:flutter/material.dart';

// Модал создания ветки
class CreateBranchDialog extends StatefulWidget {
  final Function onCreate;
  CreateBranchDialog({this.onCreate});
  @override
  _CreateBranchDialogState createState() => _CreateBranchDialogState();
}

class _CreateBranchDialogState extends State<CreateBranchDialog> {
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Создать список',
        style: TextStyle(fontSize: 16),
      ),
      children: [
        Container(
          height: 10,
        ),
        Container(
          child: TextField(
            maxLength: 30,
            onEditingComplete: () => _complete(_titleController.text),
            controller: _titleController,
            decoration: InputDecoration(
                hintText: 'Введите название списка', isDense: true),
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
              onPressed: () => _complete(_titleController.text),
            ),
          ],
        ),
      ],
    );
  }

  _complete(String text) {
    widget.onCreate(text);
    Navigator.pop(context);
  }
}
