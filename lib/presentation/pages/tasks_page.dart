import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/presentation/bloc/task_bloc.dart';
import 'package:test_app/presentation/bloc/task_event.dart';
import 'package:test_app/presentation/bloc/task_state.dart';
import 'package:test_app/presentation/pages/task_details_page.dart';
import 'package:test_app/presentation/widgets/no_tasks_background.dart';
import 'package:test_app/presentation/widgets/task_tile.dart';
import 'package:test_app/presentation/widgets/popup_button.dart';
import 'package:test_app/presentation/widgets/create_task_dialog.dart';
import 'package:test_app/presentation/widgets/color_theme_dialog.dart';
import 'package:test_app/resources/custom_color_theme.dart';

// Список задач
class TasksPage extends StatefulWidget {
  final String branchId;
  final CustomColorTheme customColorTheme;
  final VoidCallback onRefresh;
  TasksPage(this.branchId, this.customColorTheme, {this.onRefresh});
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with SingleTickerProviderStateMixin {
  TaskBloc _taskBlocSink;

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
      create: (context) => TaskBloc(TaskLoading()),
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        _taskBlocSink = BlocProvider.of<TaskBloc>(context);
        if (state is TaskLoading) {
          _taskBlocSink.add(FetchTaskList(widget.branchId));
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TaskError) {
          return Center(
            child: Text('Failed to load page'),
          );
        }
        if (state is TaskLoaded) {
          widget.onRefresh();
          return Scaffold(
            backgroundColor: widget.customColorTheme.backgroundColor,
            appBar: AppBar(
              backgroundColor: widget.customColorTheme.mainColor,
              title: Text('Задачи', style: TextStyle(color: Colors.white)),
              actions: [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: PopupButton(
                              text: state.isFiltered ? 'Показать завершенные' : 'Скрыть завершенные',
                              icon: Icons.check_circle,
                              onTap: () {
                                _taskBlocSink.add(
                                  FilterTaskList(
                                    branchId: widget.branchId,
                                    isFiltered: state.isFiltered,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: PopupButton(
                              text: 'Удалить завершенные',
                              icon: Icons.delete,
                              onTap: () {
                                _taskBlocSink.add(
                                  DeleteCompletedTasks(
                                    branchId: widget.branchId,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: PopupButton(
                              text: 'Изменить тему',
                              icon: Icons.brush,
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => ColorThemeDialog(
                                      customColorTheme: widget.customColorTheme,
                                      onChange: () {
                                        widget.onRefresh();
                                        _taskBlocSink.add(
                                          ChangeColorTheme(
                                            branchId: widget.branchId,
                                          ),
                                        );
                                      }),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ])
              ],
            ),
            body: state.taskList.isEmpty || (state.taskList.isEmpty && state.isFiltered)
                ? NoTasksBackground(state.isFiltered)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.isFiltered
                          ? Padding(
                              padding: EdgeInsets.only(left: 15, top: 5),
                              child: Text(
                                'Фильтр: скрыть завершенные задачи',
                                style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                              ),
                            )
                          : Container(),
                      for (int index = 0; index < state.taskList.length; index++) taskListView(state.taskList[index], state.isFiltered),
                    ],
                  ),
            floatingActionButton: addTaskButton(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget taskListView(Task task, bool isFiltered) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TaskTile(
        task: task,
        color: widget.customColorTheme.mainColor,
        onDelete: () {
          _taskBlocSink.add(
            DeleteTask(
              branchId: widget.branchId,
              taskId: task.id,
              isFiltered: isFiltered,
            ),
          );
        },
        onCheck: () {
          _taskBlocSink.add(
            CompleteTask(
              taskId: task.id,
              branchId: widget.branchId,
              isFiltered: isFiltered,
            ),
          );
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsPage(
                branchId: widget.branchId,
                taskId: task.id,
                customColorTheme: widget.customColorTheme,
                onRefresh: () {
                  _taskBlocSink.add(
                    UpdateTask(
                      branchId: widget.branchId,
                      taskId: task.id,
                    ),
                  );
                  widget.onRefresh();
                },
                onDelete: () {
                  _taskBlocSink.add(
                    DeleteTask(
                      branchId: widget.branchId,
                      taskId: task.id,
                    ),
                  );
                },
                onComplete: () {
                  _taskBlocSink.add(
                    CompleteTask(
                      taskId: task.id,
                      branchId: widget.branchId,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addTaskButton() {
    return FloatingActionButton(
      backgroundColor: Colors.cyan[600],
      child: Icon(Icons.add),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return CreateTaskDialog(onCreate: (title, deadline) {
              _taskBlocSink.add(
                CreateTask(
                  branchId: widget.branchId,
                  title: title,
                  deadline: deadline,
                ),
              );
            });
          },
        );
      },
    );
  }
}
