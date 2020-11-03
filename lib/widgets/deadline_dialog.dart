import 'package:flutter/material.dart';

// Модал установки дедлайна задачи
class DeadlineDialog extends StatelessWidget {
  VoidCallback onTomorrow;
  VoidCallback onNextWeek;
  VoidCallback onCustomDate;
  DeadlineDialog({this.onTomorrow, this.onNextWeek, this.onCustomDate});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        FlatButton(
          child: Text('Завтра'),
          onPressed: () => onTomorrow(),
        ),
        FlatButton(
          child: Text('На следующей неделе'),
          onPressed: () => onNextWeek(),
        ),
        FlatButton(
          child: Text('Выбрать дату'),
          onPressed: () => onCustomDate(),
        ),
      ],
    );
  }
}
