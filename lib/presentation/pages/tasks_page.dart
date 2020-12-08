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

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  var taskBlocSink;

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
        taskBlocSink = BlocProvider.of<TaskBloc>(context);
        if (state is TaskLoading) {
          taskBlocSink.add(FetchTaskList(widget.branchId));
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
                              text: state.isFiltered
                                  ? 'Показать завершенные'
                                  : 'Скрыть завершенные',
                              icon: Icons.check_circle,
                              onTap: () {
                                taskBlocSink.add(
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
                                taskBlocSink.add(
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
                                        taskBlocSink.add(
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
            body: Padding(
              padding: EdgeInsets.all(10),
              child: state.taskList.isEmpty ||
                      (state.taskList.isEmpty && state.isFiltered)
                  ? NoTasksBackground(state.isFiltered)
                  : taskListView(state.taskList, state.isFiltered),
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

  Widget taskListView(List<Task> taskList, bool isFiltered) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TaskTile(
            task: taskList[index],
            color: widget.customColorTheme.mainColor,
            onDelete: () {
              taskBlocSink.add(
                DeleteTask(
                  branchId: widget.branchId,
                  taskId: taskList[index].id,
                  isFiltered: isFiltered,
                ),
              );
            },
            onCheck: () {
              taskBlocSink.add(
                CompleteTask(
                  taskId: taskList[index].id,
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
                    taskId: taskList[index].id,
                    customColorTheme: widget.customColorTheme,
                    onRefresh: () {
                      taskBlocSink.add(
                        UpdateTask(
                          branchId: widget.branchId,
                          taskId: taskList[index].id,
                        ),
                      );
                      widget.onRefresh();
                    },
                    onDelete: () {
                      taskBlocSink.add(
                        DeleteTask(
                          branchId: widget.branchId,
                          taskId: taskList[index].id,
                        ),
                      );
                    },
                    onComplete: () {
                      taskBlocSink.add(
                        CompleteTask(
                          taskId: taskList[index].id,
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
      },
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
              taskBlocSink.add(
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
