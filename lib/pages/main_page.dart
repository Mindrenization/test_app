import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/widgets/task_tile.dart';
import 'package:test_app/widgets/create_task_dialog.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';

// Список задач
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _controller = TextEditingController();
  List tasksList = [
    Task(1, 'Задача 1', false, 0, 0),
    Task(2, 'Задача 2', false, 0, 0),
    Task(3, 'Задача 3', false, 0, 0),
  ];
  static const String emptyTaskListImage = 'assets/images/empty_tasks.svg';
  List filteredTasksList = [];
  bool isFiltered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorThemeDialog.mainColor,
        title: Text('Задачи', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            _filterTasks();
                            Navigator.pop(context);
                          },
                          child: _popupButton(
                              isFiltered
                                  ? 'Показать завершенные'
                                  : 'Скрыть завершенные',
                              Icons.check_circle)),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          _deleteCompletedTasks();
                          Navigator.pop(context);
                        },
                        child:
                            _popupButton('Удалить завершенные', Icons.delete),
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:
                              _popupButton('Сначала новые', Icons.graphic_eq)),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            showBottomSheet(
                              context: context,
                              builder: (context) =>
                                  ColorThemeDialog(onChange: () {
                                setState(() {});
                              }),
                            );
                            Navigator.pop(context);
                          },
                          child: _popupButton('Изменить тему', Icons.brush)),
                    ),
                  ])
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorThemeDialog.backgroundColor,
        child: tasksList.isEmpty
            ? Center(
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
              )
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
                    var lastTaskId = tasksList.isEmpty ? 0 : tasksList.last.id;
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
    setState(() => tasksList.removeWhere((task) => task.isComplete));
  }

  Widget _popupButton(text, icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        Container(
          width: 15,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}
