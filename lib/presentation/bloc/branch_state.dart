import 'package:test_app/data/models/branch.dart';

abstract class BranchState {
  const BranchState();
}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<Branch> branchList;
  final double totalTasks;
  final double totalCompletedTasks;
  const BranchLoaded(
    this.branchList,
    this.totalTasks,
    this.totalCompletedTasks,
  );
}
