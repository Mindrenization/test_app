import 'package:flutter/material.dart';

// Модальное окно для установки даты и времени пуш-уведомления
class NotificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        FlatButton(
            child: Text('Завтра (9:00)'),
            onPressed: () {
              int _tomorrow = DateTime.now().day + 1;
              TimeOfDay _time = TimeOfDay(hour: 9, minute: 0);
              final DateTime _deadline = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                _tomorrow,
                _time.hour,
                _time.minute,
              );
              Navigator.pop(context, _deadline);
            }),
        FlatButton(
            child: Text('На следующей неделе (9:00)'),
            onPressed: () {
              int _nextWeek = DateTime.now().day + 7;
              TimeOfDay _time = TimeOfDay(hour: 9, minute: 0);
              final DateTime _deadline = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                _nextWeek,
                _time.hour,
                _time.minute,
              );
              Navigator.pop(context, _deadline);
            }),
        FlatButton(
          child: Text('Выбрать дату и время'),
          onPressed: () async {
            DateTime _now = DateTime.now();
            int _futureYear = _now.year + 100;
            DateTime _deadline = await showDatePicker(
              context: context,
              initialDate: DateTime(_now.year, _now.month, _now.day + 1),
              firstDate: DateTime(_now.year, _now.month, _now.day + 1),
              lastDate: DateTime(_futureYear, _now.month, _now.day),
            );
            if (_deadline != null) {
              TimeOfDay _time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (_time != null)
                _deadline = DateTime(
                  _deadline.year,
                  _deadline.month,
                  _deadline.day,
                  _time.hour,
                  _time.minute,
                );
              else
                _deadline = null;
            }
            Navigator.pop(context, _deadline);
          },
        ),
      ],
    );
  }
}
