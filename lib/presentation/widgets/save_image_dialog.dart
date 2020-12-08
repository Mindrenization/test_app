import 'package:flutter/material.dart';

// Модальное окно для создания задачи
class SaveImageDialog extends StatelessWidget {
  final VoidCallback onSave;

  SaveImageDialog({this.onSave});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Выбрать данное изображение?',
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
                onSave();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
