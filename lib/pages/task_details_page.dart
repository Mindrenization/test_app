import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/models/task_step.dart';
import 'package:test_app/widgets/change_task_name_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/widgets/deadline_dialog.dart';
import 'package:test_app/widgets/delete_task_dialog.dart';
import 'package:test_app/widgets/popup_button.dart';

// Страница детализации задачи
class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;
  TaskDetailsPage({this.task, this.onRefresh, this.onDelete});
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TextEditingController _stepController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isText = false;
  DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorThemeDialog.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              centerTitle: true,
              title: Text(
                widget.task.title,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: ColorThemeDialog.mainColor,
              expandedHeight: 100,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: PopupButton(
                        text: 'Редактировать',
                        icon: Icons.line_style,
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeTaskTitleDialog(
                                task: widget.task,
                                onRefresh: () {
                                  setState(() {});
                                  widget.onRefresh();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                        child: PopupButton(
                      text: 'Удалить',
                      icon: Icons.delete,
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteTaskDialog(
                                task: widget.task,
                                onDelete: () {
                                  widget.onDelete();
                                  Navigator.pop(context);
                                },
                              );
                            });
                      },
                    )),
                  ],
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(30),
                child: Row(
                  children: [
                    Transform.translate(
                      offset: Offset(20, 28),
                      child: _topButton(),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'Создано: ${widget.task.createDate.day}.${widget.task.createDate.month}.${widget.task.createDate.year}'),
                      ),
                      for (int index = 0;
                          index < widget.task.steps.length;
                          index++)
                        _stepTile(widget.task, index),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: _addStepButton(widget.task),
                      ),
                      Divider(
                        indent: 25,
                        endIndent: 25,
                        height: 1,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: _descriptionField(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                elevation: 5,
                child: Column(
                  children: [
                    _deadlineButton(
                        text: Text(
                          'Напомнить',
                          textAlign: TextAlign.start,
                        ),
                        icon: Icon(Icons.notifications_on_outlined),
                        onTap: () {}),
                    Divider(
                      indent: 70,
                      height: 1,
                      color: Colors.black,
                    ),
                    _deadlineButton(
                      text: Text(
                        widget.task.deadline == null
                            ? 'Добавить дату выполнения'
                            : '${widget.task.deadline.day}.${widget.task.deadline.month}.${widget.task.deadline.year}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: widget.task.deadline == null
                                ? Colors.black
                                : Colors.blue),
                      ),
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: widget.task.deadline == null
                            ? Colors.black
                            : Colors.blue,
                      ),
                      onTap: () async {
                        _deadline = await showDialog(
                          context: context,
                          builder: (context) {
                            return DeadlineDialog();
                          },
                        );
                        widget.task.deadline = _deadline;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stepController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _addStepButton(task) {
    if (!isText) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isText = true;
          });
        },
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.blue,
            ),
            Container(
              width: 10,
            ),
            Text(
              'Добавить шаг',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      );
    } else if (isText) {
      return TextField(
        autofocus: true,
        controller: _stepController,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          setState(() {
            var lastStepId = task.steps.isEmpty ? 0 : task.steps.last.id;
            task.steps.add(TaskStep(++lastStepId, _stepController.text, false));
            task.maxSteps++;
            _stepController.text = '';
          });
          widget.onRefresh();
        },
      );
    }
  }

  Widget _descriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: null,
      onChanged: (text) {
        setState(() {
          widget.task.description = text;
        });
      },
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: 'Заметки по задаче...',
        labelStyle: TextStyle(
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _stepTile(task, index) {
    return Row(
      children: [
        Checkbox(
          value: task.steps[index].isComplete,
          activeColor: const Color(0xFF6202EE),
          onChanged: (value) {
            widget.onRefresh();
            setState(() {
              task.steps[index].isComplete = value;
              value ? task.completedSteps++ : task.completedSteps--;
            });
          },
        ),
        Expanded(
          child: Text(
            task.steps[index].title,
            maxLines: null,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey[700],
            ),
            onPressed: () {
              setState(() {
                widget.onRefresh();
                task.maxSteps--;
                if (task.steps[index].isComplete) {
                  task.completedSteps--;
                }
                task.steps.removeAt(index);
                if (task.steps.isEmpty) {
                  isText = false;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _topButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.task.isComplete) {
            widget.task.isComplete = false;
          } else {
            widget.task.isComplete = true;
          }
        });
        widget.onRefresh();
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Colors.cyan[600],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  spreadRadius: 1,
                  blurRadius: 3,
                  color: Colors.black38)
            ]),
        child: Icon(
          widget.task.isComplete ? Icons.close : Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _deadlineButton({Text text, Icon icon, onTap()}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 35,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: icon,
            ),
            text
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
