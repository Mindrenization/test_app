import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/task_tile.dart';
import 'package:test_app/widgets/popup_button.dart';
import 'package:test_app/widgets/create_task_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';

// Список задач
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Task> taskList = [
    Task(1, 'Задача 1', false, 0, 0, ''),
    Task(2, 'Задача 2', false, 0, 0, ''),
    Task(3, 'Задача 3', false, 0, 0, ''),
  ];
  static const String emptyTaskListImage = 'assets/images/empty_tasks.svg';
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
          child: taskList.isEmpty
              ? noTasksBackground()
              : filteredTaskList.isEmpty && isFiltered
                  ? noFilteredTasksBackground()
                  : taskListView()),
      floatingActionButton: addTaskButton(),
    );
  }

  Widget noTasksBackground() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(emptyTaskListImage),
          Container(
            height: 20,
          ),
          Text(
            'На данный момент задач нет',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget noFilteredTasksBackground() {
    return Center(
      child: Text(
        'У вас нет невыполненных задач',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, color: Colors.grey[700]),
      ),
    );
  }

  Widget taskListView() {
    return ListView.builder(
      itemCount: isFiltered ? filteredTaskList.length : taskList.length,
      itemBuilder: (context, index) {
        var task = isFiltered ? filteredTaskList[index] : taskList[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: TaskTile(
            task: task,
            onDelete: () {
              setState(
                () {
                  taskList.removeWhere((element) => element.id == task.id);
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
            return CreateTaskDialog(
                tasksList: taskList,
                onRefresh: () {
                  setState(() {});
                });
          },
        );
      },
    );
  }

  void _filterTasks() {
    if (!isFiltered) {
      if (taskList.any((task) => task.isComplete)) {
        setState(() {
          filteredTaskList =
              taskList.where((task) => !task.isComplete).toList();
          isFiltered = true;
        });
      }
    } else {
      setState(() => isFiltered = false);
    }
  }

  void _deleteCompletedTasks() {
    setState(() => taskList.removeWhere((task) => task.isComplete));
  }
}
