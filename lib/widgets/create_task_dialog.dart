import 'package:flutter/material.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/deadline_dialog.dart';

// Модал создания задачи
class CreateTaskDialog extends StatefulWidget {
  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
  final List<Task> taskList;
  final VoidCallback onRefresh;
  CreateTaskDialog({this.taskList, this.onRefresh});
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _deadline;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        'Создать задачу',
        style: TextStyle(fontSize: 16),
      ),
      children: [
        Container(
          height: 10,
        ),
        Container(
          child: TextField(
            maxLength: 30,
            onEditingComplete: () => _complete(),
            controller: _titleController,
            decoration: InputDecoration(
                hintText: 'Введите название задачи', isDense: true),
          ),
        ),
        Container(
          height: 10,
        ),
        Column(
          children: [
            _deadlineButton(
                text: 'Напомнить',
                icon: Icons.notifications_on_outlined,
                onTap: () {}),
            Container(
              height: 10,
            ),
            _deadlineButton(
                text: _deadline == null
                    ? 'Дата выполнения'
                    : '${_deadline.day}.${_deadline.month}.${_deadline.year}',
                icon: Icons.calendar_today_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeadlineDialog(
                        deadline: _deadline,
                        onRefresh: () {
                          setState(() {
                            //   int _tomorrow = DateTime.now().day + 1;
                            //   _deadline = DateTime(DateTime.now().year,
                            //       DateTime.now().month, _tomorrow);
                            // Navigator.pop(context);
                          });
                        },
                      );
                      // return SimpleDialog(
                      //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      //   children: [
                      //     FlatButton(
                      //       child: Text('Завтра'),
                      //       onPressed: () {
                      //         int _tomorrow = DateTime.now().day + 1;
                      //         setState(() {
                      //           _deadline = DateTime(DateTime.now().year,
                      //               DateTime.now().month, _tomorrow);
                      //         });
                      //         Navigator.pop(context);
                      //       },
                      //     ),
                      //     FlatButton(
                      //       child: Text('На следующей неделе'),
                      //       onPressed: () {
                      //         int _nextWeek = DateTime.now().day + 7;
                      //         setState(() {
                      //           _deadline = DateTime(DateTime.now().year,
                      //               DateTime.now().month, _nextWeek);
                      //         });
                      //         Navigator.pop(context);
                      //       },
                      //     ),
                      //     FlatButton(
                      //       child: Text('Выбрать дату'),
                      //       onPressed: () async {
                      //         var futureYear = DateTime.now().year + 100;
                      //         _deadline = await showDatePicker(
                      //           context: context,
                      //           initialDate: DateTime.now(),
                      //           firstDate: DateTime.now(),
                      //           lastDate: DateTime(futureYear,
                      //               DateTime.now().month, DateTime.now().day),
                      //         );
                      //         setState(() {});
                      //         Navigator.pop(context);
                      //       },
                      //     ),
                      //   ],
                      // );
                    },
                  );
                }),
          ],
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
              onPressed: () => _complete(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _deadlineButton({String text, IconData icon, onTap()}) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  _complete() {
    var lastTaskId = widget.taskList.isEmpty ? 0 : widget.taskList.last.id;
    widget.taskList.add(
      Task(++lastTaskId, _titleController.text, _deadline),
    );
    widget.onRefresh();
    Navigator.pop(context);
  }
}
