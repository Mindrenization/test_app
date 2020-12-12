import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app/presentation/bloc/task_details_bloc.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/presentation/pages/flickr_page.dart';
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
  TaskDetailsPage({this.branchId, this.taskId, this.customColorTheme, this.onRefresh, this.onDelete, this.onComplete});
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskDetailsBloc stepBlocSink;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(TaskDetailsLoading()),
      child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(builder: (context, state) {
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
          return SafeArea(
            child: Scaffold(
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
                        titlePadding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
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
                                          stepBlocSink.add(ChangeTaskTitle(taskId: widget.taskId, branchId: widget.branchId, title: title));
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
                          widget.customColorTheme.mainColor,
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
                            stepBlocSink.add(CompleteStep(
                              branchId: widget.branchId,
                              taskId: widget.taskId,
                              stepId: state.task.steps[index].id,
                            ));
                          },
                          onSaveDescription: (text) {
                            stepBlocSink.add(SaveDescription(
                              taskId: widget.taskId,
                              branchId: widget.branchId,
                              text: text,
                            ));
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
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.white,
                        elevation: 5,
                        child: Column(
                          children: [
                            _deadlineButton(
                                text: Text(
                                  'Напомнить',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                icon: Icon(
                                  Icons.notifications_on_outlined,
                                  color: Colors.grey[700],
                                ),
                                onTap: () {}),
                            Divider(
                              indent: 60,
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
                                      ? Colors.grey[700]
                                      : state.task.deadline.isBefore(DateTime.now())
                                          ? Colors.red
                                          : Colors.blue,
                                ),
                              ),
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: state.task.deadline == null
                                    ? Colors.grey[700]
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
                                    ) ??
                                    state.task.deadline;
                                stepBlocSink.add(SetDeadline(branchId: widget.branchId, taskId: widget.taskId, deadline: _deadline));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: _gallery(state),
                      )
                    ],
                  ),
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
          boxShadow: [BoxShadow(offset: Offset.zero, spreadRadius: 1, blurRadius: 3, color: Colors.black38)],
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 25,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: icon,
            ),
            Expanded(child: text),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _gallery(state) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset.fromDirection(1.5, 3),
            color: Colors.black26,
            spreadRadius: 0.1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < state.task.images.length; i++)
            Container(
              width: 120,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Stack(
                children: [
                  Image.file(
                    File(state.task.images[i].path),
                    height: 120,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                  GestureDetector(
                    onTap: () {
                      stepBlocSink.add(
                        DeleteImage(
                          taskId: widget.taskId,
                          branchId: widget.branchId,
                          imageId: state.task.images[i].id,
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF01A39D),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlickrPage(
                    widget.branchId,
                    widget.taskId,
                    widget.customColorTheme,
                    onSave: (imageUrl) {
                      stepBlocSink.add(
                        SaveImage(
                          branchId: widget.branchId,
                          taskId: widget.taskId,
                          imageUrl: imageUrl,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Container(
              height: 80,
              width: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF01A39D),
                boxShadow: [
                  BoxShadow(offset: Offset.fromDirection(1.5, 3), color: Colors.black26, spreadRadius: 0.1, blurRadius: 3),
                ],
              ),
              child: Icon(
                Icons.attach_file,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
