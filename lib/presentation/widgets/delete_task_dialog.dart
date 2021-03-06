import 'package:flutter/material.dart';

// Модальное окно для удаления задачи
class DeleteTaskDialog extends StatelessWidget {
  final VoidCallback onDelete;
  DeleteTaskDialog({
    this.onDelete,
  });

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
                  Navigator.pop(context);
                  onDelete();
                }),
          ],
        ),
      ],
    );
  }
}
