import 'package:flutter/material.dart';

// Модал установки дедлайна задачи
class DeadlineDialog extends StatelessWidget {
  DateTime deadline;
  VoidCallback onRefresh;
  DeadlineDialog({this.deadline, this.onRefresh});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        FlatButton(
          child: Text('Завтра'),
          onPressed: () {
            int _tomorrow = DateTime.now().day + 1;
            deadline =
                DateTime(DateTime.now().year, DateTime.now().month, _tomorrow);
            onRefresh();
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('На следующей неделе'),
          onPressed: () {
            int _nextWeek = DateTime.now().day + 7;
            deadline =
                DateTime(DateTime.now().year, DateTime.now().month, _nextWeek);
            Navigator.pop(context);
            onRefresh();
          },
        ),
        FlatButton(
          child: Text('Выбрать дату'),
          onPressed: () async {
            var futureYear = DateTime.now().year + 100;
            deadline = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(
                  futureYear, DateTime.now().month, DateTime.now().day),
            );
            Navigator.pop(context);
            onRefresh();
          },
        ),
      ],
    );
  }
}
