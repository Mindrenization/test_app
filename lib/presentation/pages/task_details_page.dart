import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app/presentation/bloc/task_details_bloc.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/resources/custom_color_theme.dart';
import 'package:test_app/presentation/widgets/change_task_name_dialog.dart';
import 'package:test_app/presentation/widgets/deadline_dialog.dart';
import 'package:test_app/presentation/widgets/delete_task_dialog.dart';
import 'package:test_app/presentation/widgets/popup_button.dart';
import 'package:test_app/presentation/widgets/step_list.dart';

// Страница детализации задачи
class TaskDetailsPage extends StatefulWidget {
  final String branchId;
  final String taskId;
  final CustomColorTheme customColorTheme;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  TaskDetailsPage(
      {this.branchId,
      this.taskId,
      this.customColorTheme,
      this.onRefresh,
      this.onDelete,
      this.onComplete});
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  var stepBlocSink;
  bool isText = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(TaskDetailsLoading()),
      child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
          builder: (context, state) {
        stepBlocSink = BlocProvider.of<TaskDetailsBloc>(context);
        if (state is TaskDetailsLoading) {
          stepBlocSink.add(
            FetchTask(taskId: widget.taskId, branchId: widget.branchId),
          );
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TaskDetailsError) {
          return Center(
            child: Text('Failed to load page'),
          );
        }
        if (state is TaskDetailsLoaded) {
          widget.onRefresh();
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
                                      state.task.title,
                                      onChange: (title) {
                                        stepBlocSink.add(ChangeTaskTitle(
                                            taskId: widget.taskId,
                                            branchId: widget.branchId,
                                            title: title));
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
                            child: _topButton(state.task.isComplete),
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
                        state.task,
                        onCreate: (title) {
                          stepBlocSink.add(
                            CreateStep(
                              title: title,
                              taskId: widget.taskId,
                              branchId: widget.branchId,
                            ),
                          );
                        },
                        onComplete: (index) {
                          stepBlocSink.add(
                            CompleteStep(
                              branchId: widget.branchId,
                              taskId: widget.taskId,
                              stepId: state.task.steps[index].id,
                            ),
                          );
                        },
                        onSaveDescription: (text) {
                          stepBlocSink.add(
                            SaveDescription(
                              taskId: widget.taskId,
                              branchId: widget.branchId,
                              text: text,
                            ),
                          );
                        },
                        onDelete: (index) {
                          stepBlocSink.add(
                            DeleteStep(
                              branchId: widget.branchId,
                              taskId: widget.taskId,
                              stepId: state.task.steps[index].id,
                            ),
                          );
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
                                    : state.task.deadline
                                            .isBefore(DateTime.now())
                                        ? Colors.red
                                        : Colors.blue,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: state.task.deadline == null
                                  ? Colors.black
                                  : state.task.deadline.isBefore(DateTime.now())
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
                                  branchId: widget.branchId,
                                  taskId: widget.taskId,
                                  deadline: _deadline));
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
    super.dispose();
  }

  Widget _topButton(bool isComplete) {
    return GestureDetector(
      onTap: () {
        widget.onComplete();
        widget.onRefresh();
        stepBlocSink.add(
          UpdateTask(taskId: widget.taskId, branchId: widget.branchId),
        );
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
          isComplete ? Icons.close : Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _deadlineButton({Text text, Icon icon, VoidCallback onTap}) {
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
