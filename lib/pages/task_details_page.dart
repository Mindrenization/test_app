import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app/blocs/task_details_bloc.dart';
import 'package:test_app/blocs/task_details_event.dart';
import 'package:test_app/blocs/task_details_state.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/resources/custom_color_theme.dart';
import 'package:test_app/widgets/change_task_name_dialog.dart';
import 'package:test_app/widgets/deadline_dialog.dart';
import 'package:test_app/widgets/delete_task_dialog.dart';
import 'package:test_app/widgets/popup_button.dart';
import 'package:test_app/widgets/step_list.dart';

// Страница детализации задачи
class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final CustomColorTheme customColorTheme;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  TaskDetailsPage(
      {this.task,
      this.customColorTheme,
      this.onRefresh,
      this.onDelete,
      this.onComplete});
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TextEditingController _descriptionController = TextEditingController();
  var stepBlocSink;
  bool isText = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(TaskDetailsEmpty()),
      child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
          builder: (context, state) {
        stepBlocSink = BlocProvider.of<TaskDetailsBloc>(context);
        if (state is TaskDetailsEmpty) {
          stepBlocSink.add(FetchTask(widget.task));
        }
        if (state is TaskDetailsError) {
          return Center(
            child: Text('Failed to load page'),
          );
        }
        if (state is TaskDetailsLoaded) {
          return Scaffold(
            backgroundColor: widget.customColorTheme.backgroundColor,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    centerTitle: true,
                    backgroundColor: widget.customColorTheme.mainColor,
                    expandedHeight: 100,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding:
                          EdgeInsets.only(left: 80, right: 40, bottom: 20),
                      title: Text(
                        state.task.title,
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
                                      widget.task,
                                      onChange: (title) {
                                        stepBlocSink.add(ChangeTaskTitle(
                                            task: widget.task, title: title));
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
                            child: _topButton(state),
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
                        state.task,
                        onCreate: (title) {
                          stepBlocSink
                              .add(CreateStep(task: widget.task, title: title));
                        },
                        onDelete: (index) {
                          stepBlocSink
                              .add(DeleteStep(task: widget.task, index: index));
                        },
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
                              state.task.deadline == null
                                  ? 'Добавить дату выполнения'
                                  : '${DateFormat('dd.MM.yyyy').format(state.task.deadline)}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: state.task.deadline == null
                                    ? Colors.black
                                    : state.task.deadline.day <
                                            DateTime.now().day
                                        ? Colors.red
                                        : Colors.blue,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: state.task.deadline == null
                                  ? Colors.black
                                  : state.task.deadline.day < DateTime.now().day
                                      ? Colors.red
                                      : Colors.blue,
                            ),
                            onTap: () async {
                              DateTime _deadline = await showDialog(
                                context: context,
                                builder: (context) {
                                  return DeadlineDialog();
                                },
                              );
                              stepBlocSink.add(SetDeadline(
                                  task: widget.task, deadline: _deadline));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _topButton(state) {
    return GestureDetector(
      onTap: () {
        widget.onComplete();
        widget.onRefresh();
        stepBlocSink.add(FetchTask(widget.task));
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
          ],
        ),
        child: Icon(
          state.task.isComplete ? Icons.close : Icons.check,
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
