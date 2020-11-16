import 'package:flutter/material.dart';
import 'package:test_app/blocs/task_bloc.dart';
import 'package:test_app/models/branch.dart';
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
  bool isFiltered = false;
  TaskBloc taskBloc = TaskBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: taskBloc.getBranch,
      initialData: widget.branch,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: snapshot.data.customColorTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: snapshot.data.customColorTheme.mainColor,
            title: Text('Задачи', style: TextStyle(color: Colors.white)),
            actions: [
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: PopupButton(
                            text: isFiltered
                                ? 'Показать завершенные'
                                : 'Скрыть завершенные',
                            icon: Icons.check_circle,
                            onTap: () {
                              isFiltered = taskBloc.filterTasks(
                                  widget.branch, isFiltered);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        PopupMenuItem(
                            child: PopupButton(
                          text: 'Удалить завершенные',
                          icon: Icons.delete,
                          onTap: () {
                            isFiltered =
                                taskBloc.deleteCompletedTasks(widget.branch);
                            widget.onRefresh();
                            Navigator.pop(context);
                          },
                        )),
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
                                    taskBloc.updateTasks(widget.branch);
                                  }),
                            );
                            Navigator.pop(context);
                          },
                        )),
                      ])
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: StreamBuilder(
              stream: taskBloc.getBranch,
              initialData: widget.branch,
              builder: (context, snapshot) {
                if (snapshot.data.tasks.isEmpty ||
                    (snapshot.data.tasks.isEmpty && isFiltered))
                  return NoTasksBackground(isFiltered);
                else
                  return taskListView(snapshot.data);
              },
            ),
          ),
          floatingActionButton: addTaskButton(),
        );
      },
    );
  }

  Widget taskListView(Branch branch) {
    return ListView.builder(
      itemCount: isFiltered ? branch.filteredTasks.length : branch.tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: TaskTile(
            task:
                isFiltered ? branch.filteredTasks[index] : branch.tasks[index],
            customColorTheme: widget.branch.customColorTheme,
            onDelete: () {
              taskBloc.deleteTask(widget.branch, index, isFiltered);
              widget.onRefresh();
            },
            onRefresh: () {
              widget.onRefresh();
              taskBloc.updateTasks(widget.branch);
            },
            onComplete: () {
              taskBloc.isComplete(branch.tasks[index]);
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return CreateTaskDialog(
              widget.branch,
              taskBloc,
            );
          },
        );
      },
    );
  }
}
