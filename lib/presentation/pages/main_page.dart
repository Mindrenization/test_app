import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/presentation/bloc/branch_bloc.dart';
import 'package:test_app/presentation/bloc/branch_event.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/presentation/pages/tasks_page.dart';
import 'package:test_app/presentation/widgets/branch_tile.dart';
import 'package:test_app/presentation/widgets/create_branch_dialog.dart';
import 'package:test_app/presentation/widgets/delete_branch_dialog.dart';
import 'package:test_app/presentation/widgets/header_card.dart';

// Главная страница
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BranchBloc _branchBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BranchBloc(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(181, 201, 253, 1),
        appBar: AppBar(
          backgroundColor: const Color(0xFF6202EE),
          title: Text(
            'Оторвись от дивана!',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<BranchBloc, BranchState>(
          builder: (context, state) {
            _branchBloc = BlocProvider.of<BranchBloc>(context);
            if (state is BranchLoading) {
              _branchBloc.add(FetchBranchList());
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BranchLoaded) {
              return Column(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 24, 10, 10),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFF86A5F5), borderRadius: BorderRadius.circular(20), boxShadow: [
                      BoxShadow(offset: Offset.fromDirection(1.5, 3), color: Colors.black26, spreadRadius: 0.1, blurRadius: 3),
                    ]),
                    child: HeaderCard(
                      totalTasks: state.totalTasks,
                      totalCompletedTasks: state.totalCompletedTasks,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 14, top: 14),
                        child: Text(
                          'Ветки задач',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                        for (int index = 0; index < state.branchList.length; index++)
                          BranchTile(
                            state.branchList[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TasksPage(
                                    state.branchList[index].id,
                                    state.branchList[index].branchTheme,
                                    onRefresh: () {
                                      _branchBloc.add(FetchBranchList());
                                    },
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteBranchDialog(
                                      onDelete: () {
                                        _branchBloc.add(
                                          DeleteBranch(
                                            state.branchList[index],
                                          ),
                                        );
                                      },
                                    );
                                  });
                            },
                          ),
                        _addBranchButton(state),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _addBranchButton(state) {
    return GestureDetector(
      key: Key('addBranchButton'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return CreateBranchDialog(
              onCreate: (title, index) {
                _branchBloc.add(CreateBranch(title, index));
              },
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
            BoxShadow(offset: Offset.fromDirection(1.5, 3), color: Colors.black26, spreadRadius: 0.1, blurRadius: 3),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
