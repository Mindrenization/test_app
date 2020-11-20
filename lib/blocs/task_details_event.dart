import 'package:test_app/models/task.dart';

abstract class TaskDetailsEvent {
  const TaskDetailsEvent();
}

class FetchTask extends TaskDetailsEvent {
  final Task task;
  const FetchTask(this.task);
}

class CreateStep extends TaskDetailsEvent {
  final Task task;
  final String title;
  const CreateStep({this.task, this.title});
}

class DeleteStep extends TaskDetailsEvent {
  final Task task;
  final int index;
  const DeleteStep({this.task, this.index});
}

class SetDeadline extends TaskDetailsEvent {
  final Task task;
  final DateTime deadline;
  const SetDeadline({this.task, this.deadline});
}

class ChangeTaskTitle extends TaskDetailsEvent {
  final Task task;
  final String title;
  const ChangeTaskTitle({this.task, this.title});
}
