import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/models/branch_theme.dart';
import 'package:test_app/presentation/bloc/task_details_bloc.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/presentation/pages/flickr_page.dart';
import 'package:test_app/presentation/widgets/notification_dialog.dart';
import 'package:test_app/presentation/widgets/change_task_name_dialog.dart';
import 'package:test_app/presentation/widgets/deadline_dialog.dart';
import 'package:test_app/presentation/widgets/delete_task_dialog.dart';
import 'package:test_app/presentation/widgets/popup_button.dart';
import 'package:test_app/presentation/widgets/step_list.dart';

// Страница детализации задачи
class TaskDetailsPage extends StatefulWidget {
  final String branchId;
  final String taskId;
  final BranchTheme branchTheme;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  TaskDetailsPage({
    this.branchId,
    this.taskId,
    this.branchTheme,
    this.onRefresh,
    this.onDelete,
    this.onComplete,
  });
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskDetailsBloc stepBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(widget.branchId, widget.taskId),
      child: BlocConsumer<TaskDetailsBloc, TaskDetailsState>(listener: (context, state) {
        if (state is UpdateTasksPage) {
          widget.onRefresh();
        }
      }, builder: (context, state) {
        stepBloc = BlocProvider.of<TaskDetailsBloc>(context);
        if (state is TaskDetailsLoading) {
          stepBloc.add(
            FetchTask(),
          );
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TaskDetailsLoaded) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: widget.branchTheme.backgroundColor,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      centerTitle: true,
                      backgroundColor: widget.branchTheme.mainColor,
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
                                          stepBloc.add(ChangeTaskTitle(title));
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
                          widget.branchTheme.mainColor,
                          onCreate: (title) {
                            stepBloc.add(
                              CreateStep(
                                title,
                              ),
                            );
                          },
                          onComplete: (index) {
                            stepBloc.add(CompleteStep(
                              state.task.steps[index].id,
                            ));
                          },
                          onSaveDescription: (text) {
                            stepBloc.add(SaveDescription(
                              text,
                            ));
                          },
                          onDelete: (index) {
                            stepBloc.add(
                              DeleteStep(
                                state.task.steps[index].id,
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
                              state.task.notification == null
                                  ? 'Напомнить'
                                  : '${DateFormat('dd.MM.yyyy (HH:mm)').format(state.task.notification)}',
                              Icons.notifications_on_outlined,
                              state.task.notification == null ? false : true,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                DateTime _notification = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return NotificationDialog();
                                      },
                                    ) ??
                                    state.task.notification;
                                stepBloc.add(
                                  SetNotification(
                                    _notification,
                                  ),
                                );
                              },
                              onDelete: () {
                                stepBloc.add(
                                  DeleteNotification(),
                                );
                              },
                            ),
                            Divider(
                              indent: 60,
                              height: 1,
                              color: Colors.black,
                            ),
                            _deadlineButton(
                              state.task.deadline == null
                                  ? 'Добавить дату выполнения'
                                  : '${DateFormat('dd.MM.yyyy').format(state.task.deadline)}',
                              Icons.calendar_today_outlined,
                              state.task.deadline == null ? false : true,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                DateTime _deadline = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeadlineDialog();
                                      },
                                    ) ??
                                    state.task.deadline;
                                stepBloc.add(
                                  SetDeadline(
                                    _deadline,
                                  ),
                                );
                              },
                              onDelete: () {
                                stepBloc.add(
                                  DeleteDeadline(),
                                );
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
        stepBloc.add(
          FetchTask(),
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
              color: Colors.black38,
            )
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

  Widget _deadlineButton(String text, IconData icon, bool isHaveValue, {VoidCallback onTap, VoidCallback onDelete}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 14),
        height: 25,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                icon,
                color: isHaveValue ? Colors.blue : Colors.grey[700],
              ),
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: isHaveValue ? Colors.blue : Colors.grey[700],
                ),
              ),
            ),
            isHaveValue
                ? InkWell(
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[700],
                    ),
                    onTap: onDelete,
                  )
                : Container(),
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
                      stepBloc.add(
                        DeleteImage(
                          state.task.images[i].id,
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4, right: 4),
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
                    widget.branchTheme,
                    onSave: (imageUrl) {
                      stepBloc.add(
                        SaveImage(
                          imageUrl,
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
