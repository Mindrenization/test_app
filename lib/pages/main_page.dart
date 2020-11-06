import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/pages/tasks_page.dart';
import 'package:test_app/widgets/circular_progress_bar.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/widgets/create_branch_dialog.dart';
import 'package:test_app/widgets/delete_branch_dialog.dart';
import 'package:test_app/widgets/linear_progress_bar.dart';

// Главная страница
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const String mainLogo = 'assets/images/main_page_logo.svg';
  int completedTasks;
  List<Branch> branchList = [];

  @override
  Widget build(BuildContext context) {
    double totalTasks = 0;
    double totalCompletedTasks = 0;
    for (var i = 0; i < branchList.length; i++) {
      totalTasks += branchList[i].tasks.length;
      totalCompletedTasks +=
          branchList[i].tasks.where((task) => task.isComplete).length;
    }
    return Scaffold(
      backgroundColor: ColorThemeDialog.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorThemeDialog.mainColor,
        title: Text(
          'Оторвись от дивана!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: const Color(0xFF86A5F5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset.fromDirection(1.5, 3),
                      color: Colors.black26,
                      spreadRadius: 0.1,
                      blurRadius: 3),
                ]),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Все задания',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: totalTasks != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Завершено ${totalCompletedTasks.toInt()} задач из ${totalTasks.toInt()}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: LinearProgressBar(
                                  totalCompletedTasks / totalTasks),
                            ),
                          ],
                        )
                      : Text(
                          'На данный момент\nзадачи отсутствуют',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    mainLogo,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Text(
                  'Ветки задач',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                for (int index = 0; index < branchList.length; index++)
                  _branchTile(index),
                _addBranchButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addBranchButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return CreateBranchDialog(
              branchList: branchList,
              onRefresh: () => setState(() {}),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 90, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF01A39D),
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(1.5, 3),
                color: Colors.black26,
                spreadRadius: 0.1,
                blurRadius: 3),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _branchTile(index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksPage(
              branchList[index],
              onRefresh: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(1.5, 3),
                color: Colors.black26,
                spreadRadius: 0.1,
                blurRadius: 3),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 35, top: 20, left: 15),
                  child: CircularProgressBar(branchList[index].tasks.length == 0
                      ? 0
                      : branchList[index]
                              .tasks
                              .where((task) => task.isComplete)
                              .length /
                          branchList[index].tasks.length),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteBranchDialog(
                            branch: branchList[index],
                            onDelete: () {
                              setState(
                                () => branchList.removeWhere((branch) =>
                                    branch.id == branchList[index].id),
                              );
                            },
                          );
                        });
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
            Text(
              branchList[index].title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${branchList[index].tasks.length} задач(и)',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[100],
                  ),
                  child: Text(
                    '${completedTasks = branchList[index].tasks.where((task) => task.isComplete).length} сделано',
                    style: TextStyle(color: Colors.green[800], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 75,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red[100]),
                  child: Text(
                    '${branchList[index].tasks.length - completedTasks} осталось',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
