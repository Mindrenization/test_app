import 'package:flutter/material.dart';

// Модал удаления ветки
class DeleteBranchDialog extends StatelessWidget {
  final branch;
  final VoidCallback onDelete;
  DeleteBranchDialog({this.branch, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Вы точно хотите удалить эту ветку?',
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
