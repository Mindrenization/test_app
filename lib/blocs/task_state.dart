import 'package:test_app/models/branch.dart';

abstract class TaskState {
  const TaskState();
}

class TaskEmpty extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final Branch branch;
  final bool isFiltered;
  const TaskLoaded({this.branch, this.isFiltered = false})
      : assert(branch != null);
}

class TaskError extends TaskState {}
