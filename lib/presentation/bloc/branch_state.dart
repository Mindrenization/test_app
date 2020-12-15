import 'package:test_app/data/models/branch.dart';

abstract class BranchState {
  const BranchState();
}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<Branch> branchList;
  double get totalTasks {
    double totalTasksCount = 0.0;
    for (int i = 0; i < branchList.length; i++) {
      totalTasksCount += branchList[i].tasks.length;
    }
    return totalTasksCount;
  }

  double get totalCompletedTasks {
    double _totalCompletedTasks = 0.0;
    for (int i = 0; i < branchList.length; i++) {
      _totalCompletedTasks += branchList[i].tasks.where((task) => task.isComplete).length;
    }
    return _totalCompletedTasks;
  }

  const BranchLoaded(
    this.branchList,
  );
}
