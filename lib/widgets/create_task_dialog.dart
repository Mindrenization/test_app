import 'package:flutter/material.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/deadline_dialog.dart';
import 'package:intl/intl.dart';

// Модальное окно для создания задачи
class CreateTaskDialog extends StatefulWidget {
  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
  final List<Task> taskList;
  final VoidCallback onRefresh;
  CreateTaskDialog(this.taskList, {this.onRefresh});
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
            onEditingComplete: () {
              _complete();
              widget.onRefresh();
            },
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
                    : '${DateFormat('dd.MM.yyyy').format(_deadline)}',
                icon: Icons.calendar_today_outlined,
                onTap: () async {
                  _deadline = await showDialog(
                    context: context,
                    builder: (context) {
                      return DeadlineDialog();
                    },
                  );
                  setState(() {});
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
              onPressed: () {
                _complete();
                widget.onRefresh();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
      Task(++lastTaskId, _titleController.text, deadline: _deadline),
    );
    widget.onRefresh();
    Navigator.pop(context);
  }
}
