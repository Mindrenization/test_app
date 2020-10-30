import 'package:flutter/material.dart';

// Кнопка с иконкой для popup меню
class DeleteTaskDialog extends StatefulWidget {
  final task;
  final VoidCallback onDelete;
  DeleteTaskDialog({this.task, this.onDelete});
  @override
  _DeleteTaskDialogState createState() => _DeleteTaskDialogState();
}

class _DeleteTaskDialogState extends State<DeleteTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Вы точно хотите удалить это задание?',
        style: TextStyle(fontSize: 16),
      ),
      children: [
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
                  widget.onDelete();
                  Navigator.pop(context);
                }),
          ],
        ),
      ],
    );
  }
}
