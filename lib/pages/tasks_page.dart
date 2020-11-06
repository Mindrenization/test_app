import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/models/branch.dart';
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

class _TasksPageState extends State<TasksPage> {
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: widget.branch.tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(emptyTaskListImage),
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 110),
                      child: Text(
                        'На данный момент в этой ветке нет задач',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              )
            : filteredTaskList.isEmpty && isFiltered
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(emptyTaskListImage),
                        Container(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 90),
                          child: Text(
                            'У вас нет невыполненных задач',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: isFiltered
                        ? filteredTaskList.length
                        : widget.branch.tasks.length,
                    itemBuilder: (context, index) {
                      var task = isFiltered
                          ? filteredTaskList[index]
                          : widget.branch.tasks[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TaskTile(
                          task: task,
                          onDelete: () {
                            setState(
                              () {
                                widget.branch.tasks.removeWhere(
                                    (element) => element.id == task.id);
                                if (isFiltered) {
                                  filteredTaskList.removeWhere(
                                      (element) => element.id == task.id);
                                }
                              },
                            );
                          },
                          onRefresh: () => widget.onRefresh(),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[600],
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CreateTaskDialog(
                  taskList: widget.branch.tasks,
                  onRefresh: () {
                    setState(() {});
                  });
            },
          );
        },
      ),
    );
  }

  void _filterTasks() {
    if (!isFiltered) {
      if (widget.branch.tasks.any((task) => task.isComplete)) {
        setState(() {
          filteredTaskList =
              widget.branch.tasks.where((task) => !task.isComplete).toList();
          isFiltered = true;
        });
      }
    } else {
      setState(() => isFiltered = false);
    }
  }

  void _deleteCompletedTasks() {
    setState(() => widget.branch.tasks.removeWhere((task) => task.isComplete));
  }
}
