import 'dart:async';

import 'package:test_app/blocs/bloc.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/repository/branch_list.dart';

class BranchBloc extends Bloc {
  StreamController<List<Branch>> _controller = StreamController.broadcast();

  Stream<List<Branch>> get getBranch => _controller.stream;
  void createBranch(String value) {
    var lastTaskId =
        BranchList.branchList.isEmpty ? 0 : BranchList.branchList.last.id;
    BranchList.branchList.add(
      Branch(++lastTaskId, value),
    );
    _controller.sink.add(BranchList.branchList);
  }

  void updateBranch() {
    _controller.sink.add(BranchList.branchList);
  }

  void deleteBranch(index) {
    BranchList.branchList
        .removeWhere((branch) => branch.id == BranchList.branchList[index].id);
    _controller.sink.add(BranchList.branchList);
  }

  int completedTasks(index) {
    return BranchList.branchList[index].tasks
        .where((Task task) => task.isComplete)
        .length;
  }

  int uncompletedTasks(index) {
    return BranchList.branchList[index].tasks
        .where((Task task) => !task.isComplete)
        .length;
  }

  double totalTasks() {
    double _totalTasks = 0;
    if (BranchList.branchList != null)
      for (var i = 0; i < BranchList.branchList.length; i++) {
        _totalTasks += BranchList.branchList[i].tasks.length;
      }
    return _totalTasks;
  }

  double totalCompletedTasks() {
    double _totalCompletedTasks = 0;
    if (BranchList.branchList != null)
      for (var i = 0; i < BranchList.branchList.length; i++) {
        _totalCompletedTasks += BranchList.branchList[i].tasks
            .where((Task task) => task.isComplete)
            .length;
      }
    return _totalCompletedTasks;
  }

  dispose() {
    _controller.close();
  }
}
