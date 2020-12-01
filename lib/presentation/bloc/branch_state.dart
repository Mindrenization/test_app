import 'package:test_app/data/models/branch.dart';

abstract class BranchState {
  const BranchState();
}

class BranchEmpty extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<Branch> branchList;
  final totalTasks;
  final totalCompletedTasks;

  const BranchLoaded({
    this.branchList,
    this.totalCompletedTasks,
    this.totalTasks,
  });
}

class BranchError extends BranchState {}
