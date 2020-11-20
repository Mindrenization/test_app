import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/task_bloc.dart';
import 'package:test_app/blocs/task_event.dart';
import 'package:test_app/blocs/task_state.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/pages/task_details_page.dart';
import 'package:test_app/widgets/no_tasks_background.dart';
import 'package:test_app/widgets/task_tile.dart';
import 'package:test_app/widgets/popup_button.dart';
import 'package:test_app/widgets/create_task_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';

// Список задач
class TasksPage extends StatefulWidget {
  final Branch branch;
  final VoidCallback onRefresh;
  TasksPage(this.branch, {this.onRefresh});
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
      create: (context) => TaskBloc(TaskEmpty()),
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        taskBlocSink = BlocProvider.of<TaskBloc>(context);
        if (state is TaskEmpty) {
          taskBlocSink.add(FetchTaskList(widget.branch));
        }
        if (state is TaskError) {
          return Center(
            child: Text('Failed to load page'),
          );
        }
        if (state is TaskLoaded) {
          return Scaffold(
            backgroundColor: state.branch.customColorTheme.backgroundColor,
            appBar: AppBar(
              backgroundColor: state.branch.customColorTheme.mainColor,
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
                                  FilterTaskList(widget.branch,
                                      isFiltered: state.isFiltered),
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
                                  DeletedCompletedTasks(
                                    widget.branch,
                                  ),
                                );
                                widget.onRefresh();
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
                                      branch: widget.branch,
                                      onChange: () {
                                        widget.onRefresh();
                                        taskBlocSink
                                            .add(FetchTaskList(widget.branch));
                                      }),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ])
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: state.branch.tasks.isEmpty ||
                      (state.branch.tasks.isEmpty && state.isFiltered)
                  ? NoTasksBackground(state.isFiltered)
                  : taskListView(state.branch, state.isFiltered),
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

  Widget taskListView(Branch branch, bool isFiltered) {
    return ListView.builder(
      itemCount: isFiltered ? branch.filteredTasks.length : branch.tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: TaskTile(
            task:
                isFiltered ? branch.filteredTasks[index] : branch.tasks[index],
            onDelete: () {
              taskBlocSink.add(DeleteTask(
                  branch: widget.branch, index: index, isFiltered: isFiltered));
              widget.onRefresh();
            },
            onRefresh: () {
              taskBlocSink.add(FetchTaskList(widget.branch));
              widget.onRefresh();
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                    task: isFiltered
                        ? branch.filteredTasks[index]
                        : branch.tasks[index],
                    customColorTheme: branch.customColorTheme,
                    onRefresh: () {
                      taskBlocSink.add(FetchTaskList(widget.branch));
                      widget.onRefresh();
                    },
                    onDelete: () {
                      taskBlocSink.add(DeleteTask(
                          branch: widget.branch,
                          index: index,
                          isFiltered: isFiltered));
                      widget.onRefresh();
                    },
                    onComplete: () {
                      taskBlocSink.add(CompleteTask(
                          task: branch.tasks[index], branch: widget.branch));
                      widget.onRefresh();
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
            return CreateTaskDialog((title, deadline) {
              taskBlocSink.add(CreateTask(
                  branch: widget.branch, title: title, deadline: deadline));
            });
          },
        );
        widget.onRefresh();
      },
    );
  }
}
