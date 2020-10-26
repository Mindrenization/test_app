import 'package:flutter/material.dart';
import 'TaskPage.dart';
import '../models/TaskModel.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List tasksList = [
    Task('Задача 1', false, 0, 0),
    Task('Задача 2', false, 2, 4),
    Task('Задача 3', false, 1, 3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Скрыть завершенные')),
                    PopupMenuItem(child: Text('Удалить завершенные')),
                    PopupMenuItem(child: Text('Сначала новые')),
                    PopupMenuItem(child: Text('Изменить тему')),
                  ])
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          itemCount: tasksList.length,
          itemBuilder: (context, index) {
            var task = tasksList[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPage(),
                      settings: RouteSettings(
                        arguments: task,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isComplete,
                          activeColor: Color.fromRGBO(98, 2, 238, 1),
                          onChanged: (value) {
                            setState(() => task.isComplete = value);
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(fontSize: 18),
                            ),
                            task.maxSteps == 0
                                ? Container()
                                : Text(
                                    '${task.currentStep} из ${task.maxSteps}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color.fromRGBO(98, 2, 238, 1),
                          ),
                          onPressed: () {
                            final snackBar = SnackBar(
                              content: Text('Функционал в разработке'),
                              action: SnackBarAction(
                                label: 'Ок',
                                onPressed: () {},
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 5,
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[600],
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
