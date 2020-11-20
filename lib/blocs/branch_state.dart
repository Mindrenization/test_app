import 'package:test_app/models/branch.dart';

abstract class BranchState {
  const BranchState();
}

class BranchEmpty extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<Branch> branchList;

  const BranchLoaded({this.branchList}) : assert(branchList != null);
}

class BranchError extends BranchState {}
