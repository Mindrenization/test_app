import 'package:test_app/data/models/task.dart';

abstract class TaskState {
  const TaskState();
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final bool isFiltered;
  final List<Task> taskList;

  const TaskLoaded({this.isFiltered = false, this.taskList});
}

class TaskError extends TaskState {}
