import 'package:test_app/models/task.dart';

abstract class TaskDetailsState {
  const TaskDetailsState();
}

class TaskDetailsEmpty extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final Task task;

  const TaskDetailsLoaded({this.task}) : assert(task != null);
}

class TaskDetailsError extends TaskDetailsState {}
