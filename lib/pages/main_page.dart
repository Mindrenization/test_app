import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/blocs/branch_bloc.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/pages/tasks_page.dart';
import 'package:test_app/widgets/circular_progress_bar.dart';
import 'package:test_app/widgets/color_theme_dialog.dart';
import 'package:test_app/widgets/create_branch_dialog.dart';
import 'package:test_app/widgets/delete_branch_dialog.dart';
import 'package:test_app/widgets/linear_progress_bar.dart';
import 'package:test_app/resources/resources.dart';
import 'package:test_app/repository/branch_list.dart';

// Главная страница
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BranchBloc branchBloc;

  @override
  void initState() {
    super.initState();
    branchBloc = BranchBloc();
  }

  @override
  void dispose() {
    branchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: _headerCard()),
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
          StreamBuilder(
            stream: branchBloc.getBranch,
            builder: (context, snapshot) {
              return Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    for (int index = 0;
                        index < BranchList.branchList.length;
                        index++)
                      _branchTile(index, snapshot),
                    _addBranchButton(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return StreamBuilder(
      stream: branchBloc.getBranch,
      builder: (context, snapshot) {
        return Stack(
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
              child: branchBloc.totalTasks() != 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Завершено ${branchBloc.totalCompletedTasks().toInt()} задач из ${branchBloc.totalTasks().toInt()}',
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
                              branchBloc.totalCompletedTasks() /
                                  branchBloc.totalTasks()),
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
                Resources.mainLogo,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _addBranchButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return CreateBranchDialog(
              branchBloc: branchBloc,
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

  Widget _branchTile(index, snapshot) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksPage(
              snapshot.data[index],
              onRefresh: () {
                branchBloc.updateBranch();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 35, top: 20, left: 5),
                  child: CircularProgressBar(
                      snapshot.data[index].tasks.length == 0
                          ? 0
                          : snapshot.data[index].tasks
                                  .where((Task task) => task.isComplete)
                                  .length /
                              snapshot.data[index].tasks.length),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteBranchDialog(
                            index: index,
                            branchBloc: branchBloc,
                          );
                        });
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
            Text(
              snapshot.data[index].title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${snapshot.data[index].tasks.length} задач(и)',
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
                  child: StreamBuilder(
                    stream: branchBloc.getBranch,
                    builder: (context, builder) {
                      return Text(
                        '${branchBloc.completedTasks(index)} сделано',
                        style:
                            TextStyle(color: Colors.green[800], fontSize: 12),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
                Container(
                  width: 75,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red[100]),
                  child: StreamBuilder(
                    stream: branchBloc.getBranch,
                    builder: (context, builder) {
                      return Text(
                        '${branchBloc.uncompletedTasks(index)} осталось',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      );
                    },
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
