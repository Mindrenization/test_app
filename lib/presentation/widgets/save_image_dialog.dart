import 'package:flutter/material.dart';

class SaveImageDialog extends StatelessWidget {
  final Function onSave;
  final imageUrl;
  SaveImageDialog(this.imageUrl, {this.onSave});

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
                onSave(imageUrl);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
