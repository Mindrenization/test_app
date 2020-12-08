import 'package:test_app/data/models/task.dart';

abstract class TaskDetailsState {
  const TaskDetailsState();
}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final Task task;

  const TaskDetailsLoaded({this.task});
}

class TaskDetailsError extends TaskDetailsState {}
