import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/create_task_dialog.dart';
import '../widgets/color_theme_dialog.dart';

// Список задач
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Color currentColor = ColorThemeDialog.currentColor;
  TextEditingController _controller = TextEditingController();
  List tasksList = [
    Task(1, 'Задача 1', false, 0, 0),
    Task(2, 'Задача 2', false, 2, 4),
    Task(3, 'Задача 3', false, 1, 3),
  ];

  List filteredTasksList = [];
  bool isFiltered = false;

  void _filterTasks() {
    if (!isFiltered) {
      if (tasksList.any((task) => task.isComplete)) {
        setState(() {
          filteredTasksList =
              tasksList.where((task) => !task.isComplete).toList();
          isFiltered = true;
        });
      }
    } else {
      setState(() => isFiltered = false);
    }
  }

  void _deleteCompletedTasks() {
    for (var index = 0; index < tasksList.length; index++) {
      if (tasksList[index].isComplete) {
        setState(() {
          tasksList.removeAt(index);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorThemeDialog.currentColor,
        title: Text('Задачи', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.grey,
                          ),
                          FlatButton(
                            child: Text(
                              isFiltered
                                  ? 'Показать завершенные'
                                  : 'Скрыть завершенные',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            onPressed: () {
                              _filterTasks();
                            },
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.grey,
                          ),
                          FlatButton(
                            child: Text(
                              'Удалить завершенные',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            onPressed: () {
                              _deleteCompletedTasks();
                            },
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.graphic_eq,
                            color: Colors.grey,
                          ),
                          FlatButton(
                            child: Text(
                              'Сначала новые',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            onPressed: () {
                              print(ColorThemeDialog.currentColor);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.brush,
                            color: Colors.grey,
                          ),
                          FlatButton(
                            child: Text(
                              'Изменить тему',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            onPressed: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => ColorThemeDialog(() {
                                  setState(() {});
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ])
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: tasksList.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/empty_tasks.svg'),
                  Container(
                    height: 20,
                  ),
                  Text(
                    'На данный момент задач нет',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.grey[700]),
                  ),
                ],
              ))
            : filteredTasksList.isEmpty && isFiltered
                ? Center(
                    child: Text(
                    'У вас нет невыполненных задач',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.grey[700]),
                  ))
                : ListView.builder(
                    itemCount: isFiltered
                        ? filteredTasksList.length
                        : tasksList.length,
                    itemBuilder: (context, index) {
                      var task = isFiltered
                          ? filteredTasksList[index]
                          : tasksList[index];
                      return TaskTile(
                          task: task,
                          onDelete: () {
                            setState(() {
                              tasksList.removeWhere(
                                  (element) => element.id == task.id);
                              if (isFiltered) {
                                filteredTasksList.removeWhere(
                                    (element) => element.id == task.id);
                              }
                            });
                          });
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
                  controller: _controller,
                  onCreate: () {
                    var text = _controller.text;
                    var lastTaskId = tasksList.isEmpty ? 1 : tasksList.last.id;
                    setState(
                      () =>
                          tasksList.add(Task(++lastTaskId, text, false, 0, 0)),
                    );
                    Navigator.pop(context);
                    _controller.clear();
                  });
            },
          );
        },
      ),
    );
  }
}
