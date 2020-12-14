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

// Список задач
class TasksPage extends StatefulWidget {
  final String branchId;
  final Color mainColor;
  final Color backgroundColor;
  final VoidCallback onRefresh;
  TasksPage(this.branchId, this.mainColor, this.backgroundColor, {this.onRefresh});
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with SingleTickerProviderStateMixin {
  TaskBloc _taskBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(widget.branchId, widget.mainColor, widget.backgroundColor),
      child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
        if (state is UpdateMainPage) {
          widget.onRefresh();
        }
      }, builder: (context, state) {
        _taskBloc = BlocProvider.of<TaskBloc>(context);
        if (state is TaskLoading) {
          _taskBloc.add(FetchTaskList());
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TaskLoaded) {
          return Scaffold(
            backgroundColor: state.backgroundColor,
            appBar: AppBar(
              backgroundColor: state.mainColor,
              title: Text('Задачи', style: TextStyle(color: Colors.white)),
              actions: [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: PopupButton(
                              text: state.isFiltered ? 'Показать завершенные' : 'Скрыть завершенные',
                              icon: Icons.check_circle,
                              onTap: () {
                                _taskBloc.add(
                                  FilterTaskList(
                                    state.isFiltered,
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
                                _taskBloc.add(
                                  DeleteCompletedTasks(),
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
                                  builder: (context) => ColorThemeDialog(onChange: (mainColor, backgroundColor) {
                                    widget.onRefresh();
                                    _taskBloc.add(
                                      ChangeColorTheme(
                                        mainColor,
                                        backgroundColor,
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
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state.isFiltered
                              ? Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 10),
                                  child: Text(
                                    'Фильтр: скрыть завершенные задачи',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                                  ),
                                )
                              : Container(),
                          for (int index = 0; index < state.taskList.length; index++)
                            taskListView(
                              state.taskList[index],
                              state.isFiltered,
                              state.mainColor,
                              state.backgroundColor,
                            ),
                        ],
                      ),
                    ),
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

  Widget taskListView(Task task, bool isFiltered, Color mainColor, Color backgroundColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TaskTile(
        task: task,
        color: mainColor,
        onDelete: () {
          _taskBloc.add(
            DeleteTask(
              task.id,
              isFiltered: isFiltered,
            ),
          );
        },
        onCheck: () {
          _taskBloc.add(
            CompleteTask(
              task.id,
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
                mainColor: mainColor,
                backgroundColor: backgroundColor,
                onRefresh: () {
                  _taskBloc.add(
                    UpdateTask(
                      task.id,
                    ),
                  );
                  widget.onRefresh();
                },
                onDelete: () {
                  _taskBloc.add(
                    DeleteTask(
                      task.id,
                    ),
                  );
                },
                onComplete: () {
                  _taskBloc.add(
                    CompleteTask(
                      task.id,
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
            return CreateTaskDialog(onCreate: (title, deadline, notification) {
              _taskBloc.add(
                CreateTask(
                  title,
                  deadline,
                  notification,
                ),
              );
            });
          },
        );
      },
    );
  }
}
