import 'package:flutter/material.dart';
import 'package:test_app/blocs/task_bloc.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/models/task.dart';
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
  List<Task> filteredTaskList = [];
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
    return Scaffold(
      backgroundColor: ColorThemeDialog.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorThemeDialog.mainColor,
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
                          isFiltered = taskBloc.filterTasks(widget.branch.tasks,
                              filteredTaskList, isFiltered);
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
                            taskBloc.deleteCompletedTasks(widget.branch.tasks);
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
                          builder: (context) => ColorThemeDialog(onChange: () {
                            setState(() {});
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
          stream: taskBloc.getTasks,
          initialData: widget.branch.tasks,
          builder: (context, snapshot) {
            if (snapshot.data.isEmpty || (snapshot.data.isEmpty && isFiltered))
              return NoTasksBackground(isFiltered);
            else
              return taskListView(snapshot.data);
          },
        ),
      ),
      floatingActionButton: addTaskButton(),
    );
  }

  Widget taskListView(List<Task> taskList) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: TaskTile(
            task: taskList[index],
            onDelete: () {
              taskBloc.deleteTask(
                  taskList, index, isFiltered, filteredTaskList);
              widget.onRefresh();
            },
            onRefresh: () {
              widget.onRefresh();
              taskBloc.updateTasks(taskList);
            },
            onComplete: () {
              taskBloc.isComplete(taskList[index]);
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
              widget.branch.tasks,
              taskBloc,
            );
          },
        );
      },
    );
  }
}
