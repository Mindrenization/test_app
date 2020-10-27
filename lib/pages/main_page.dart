import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/create_task.dart';

// Список задач

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _controller = TextEditingController();
  List tasksList = [
    Task('Задача 1', false, 0, 0),
    Task('Задача 2', false, 2, 4),
    Task('Задача 3', false, 1, 3),
  ];
  List filteredTasksList = [];
  bool isFiltered = false;

  void _filterTasks() {
    if (!isFiltered) {
      if (!tasksList.every((task) => task.isComplete == false)) {
        setState(() {
          filteredTasksList =
              tasksList.where((task) => task.isComplete == false).toList();
          isFiltered = true;
        });
      }
    } else {
      setState(() => isFiltered = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                              for (var index = 0;
                                  index < tasksList.length;
                                  index++) {
                                if (tasksList[index].isComplete == true) {
                                  setState(() {
                                    tasksList.removeAt(index);
                                  });
                                }
                              }
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
                            onPressed: () {},
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
                                builder: (context) => IntrinsicHeight(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                        ),
                                        Text(
                                          'Выбор темы',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Container(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF6202EE),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              height: 30,
                                              width: 70,
                                              child: FlatButton(
                                                  child: Text('Цвет',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[200])),
                                                  onPressed: null),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF6202EE),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              height: 30,
                                              width: 70,
                                              child: FlatButton(
                                                  child: Text('Фото',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[200])),
                                                  onPressed: null),
                                            ),
                                          ],
                                        ),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.start,
                                          children: [
                                            Radio(
                                                value: null,
                                                groupValue: null,
                                                onChanged: null),
                                            Radio(
                                                value: null,
                                                groupValue: null,
                                                onChanged: null),
                                            Radio(
                                                value: null,
                                                groupValue: null,
                                                onChanged: null),
                                            Radio(
                                                value: null,
                                                groupValue: null,
                                                onChanged: null),
                                            Radio(
                                                value: null,
                                                groupValue: null,
                                                onChanged: null),
                                            Radio(
                                                value: null,
                                                groupValue: null,
                                                onChanged: null),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
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
                    Container(height: 20),
                    Text(
                      'На данный момент задач нет',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.grey[700]),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount:
                    isFiltered ? filteredTasksList.length : tasksList.length,
                itemBuilder: (context, index) {
                  var task =
                      isFiltered ? filteredTasksList[index] : tasksList[index];
                  return TaskTile(task, () {
                    setState(() => tasksList.removeAt(index));
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
              return CreateTask(_controller, () {
                var text = _controller.text;
                setState(
                  () => tasksList.add(Task(text, false, 0, 0)),
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
