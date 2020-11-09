import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/task_tile.dart';
import 'package:test_app/widgets/popup_button.dart';
import 'package:test_app/widgets/create_task_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/resources/resources.dart';

// Список задач
class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _taskList = [
    Task(0, 'Задача 1'),
    Task(1, 'Задача 2'),
    Task(2, 'Задача 3'),
  ];
  List filteredTaskList = [];
  bool isFiltered = false;

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
                          _filterTasks();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                        child: PopupButton(
                      text: 'Удалить завершенные',
                      icon: Icons.delete,
                      onTap: () {
                        _deleteCompletedTasks();
                        Navigator.pop(context);
                      },
                    )),
                    PopupMenuItem(
                        child: PopupButton(
                      text: 'Сначала новые',
                      icon: Icons.graphic_eq,
                      onTap: () {
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
          child: _taskList.isEmpty || (filteredTaskList.isEmpty && isFiltered)
              ? noTasksBackground(isFiltered)
              : taskListView()),
      floatingActionButton: addTaskButton(),
    );
  }

  Widget noTasksBackground(bool isFiltered) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Resources.emptyTaskListImage),
          Container(
            height: 20,
          ),
          isFiltered
              ? Text(
                  'У вас нет невыполненных задач',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.grey[700]),
                )
              : Text(
                  'На данный момент задач нет',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.grey[700]),
                ),
        ],
      ),
    );
  }

  Widget taskListView() {
    return ListView.builder(
      itemCount: isFiltered ? filteredTaskList.length : _taskList.length,
      itemBuilder: (context, index) {
        var task = isFiltered ? filteredTaskList[index] : _taskList[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: TaskTile(
            task: task,
            onDelete: () {
              setState(
                () {
                  _taskList.removeWhere((element) => element.id == task.id);
                  if (isFiltered) {
                    filteredTaskList
                        .removeWhere((element) => element.id == task.id);
                  }
                },
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return CreateTaskDialog(_taskList, onRefresh: () {
              setState(() {});
            });
          },
        );
      },
    );
  }

  void _filterTasks() {
    if (!isFiltered) {
      if (_taskList.any((task) => task.isComplete)) {
        setState(() {
          filteredTaskList =
              _taskList.where((task) => !task.isComplete).toList();
          isFiltered = true;
        });
      }
    } else {
      setState(() => isFiltered = false);
    }
  }

  void _deleteCompletedTasks() {
    setState(() => _taskList.removeWhere((task) => task.isComplete));
  }
}
