import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/change_task_name_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/widgets/deadline_dialog.dart';
import 'package:test_app/widgets/delete_task_dialog.dart';
import 'package:test_app/widgets/popup_button.dart';
import 'package:test_app/widgets/step_list.dart';

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
              backgroundColor: ColorThemeDialog.mainColor,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(left: 80, right: 40, bottom: 20),
                title: Text(
                  widget.task.title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
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
                child: StepList(
                  widget.task,
                  onRefresh: () {
                    widget.onRefresh();
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                            : '${DateFormat('dd.MM.yyyy').format(widget.task.deadline)}',
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
                        DateTime _deadline = await showDialog(
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
