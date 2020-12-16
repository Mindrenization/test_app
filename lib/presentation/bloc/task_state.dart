import 'package:test_app/data/models/branch_theme.dart';
import 'package:test_app/data/models/task.dart';

abstract class TaskState {
  const TaskState();
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> taskList;
  final BranchTheme branchTheme;
  final bool isFiltered;

  const TaskLoaded(
    this.taskList,
    this.branchTheme, {
    this.isFiltered = false,
  });
}

class UpdateMainPage extends TaskState {}
