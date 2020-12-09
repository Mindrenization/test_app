import 'package:flutter/material.dart';

// Модальное окно для установки дедлайна задачи
class DeadlineDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        FlatButton(
            child: Text('Завтра'),
            onPressed: () {
              int _tomorrow = DateTime.now().day + 1;
              final DateTime _deadline = DateTime(
                  DateTime.now().year, DateTime.now().month, _tomorrow);
              Navigator.pop(context, _deadline);
            }),
        FlatButton(
            child: Text('На следующей неделе'),
            onPressed: () {
              int _nextWeek = DateTime.now().day + 7;
              final DateTime _deadline = DateTime(
                  DateTime.now().year, DateTime.now().month, _nextWeek);
              Navigator.pop(context, _deadline);
            }),
        FlatButton(
          child: Text('Выбрать дату'),
          onPressed: () async {
            var now = DateTime.now();
            var futureYear = now.year + 100;
            DateTime _deadline = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: now,
              lastDate: DateTime(futureYear, now.month, now.day),
            );
            if (_deadline != null)
              _deadline = DateTime(
                  _deadline.year, _deadline.month, _deadline.day, 23, 59, 59);
            Navigator.pop(context, _deadline);
          },
        ),
      ],
    );
  }
}
