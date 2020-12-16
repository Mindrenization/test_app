import 'package:test_app/data/models/branch_theme.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class FetchTaskList extends TaskEvent {
  BranchTheme branchTheme;
  FetchTaskList(this.branchTheme);
}

class CreateTask extends TaskEvent {
  final String title;
  final DateTime deadline;
  final DateTime notification;
  const CreateTask(this.title, this.deadline, this.notification);
}

class ChangeColorTheme extends TaskEvent {
  final int index;
  const ChangeColorTheme(this.index);
}

class DeleteTask extends TaskEvent {
  final String taskId;
  final bool isFiltered;
  const DeleteTask(this.taskId, {this.isFiltered = false});
}

class CompleteTask extends TaskEvent {
  final String taskId;
  final bool isFiltered;
  const CompleteTask(
    this.taskId, {
    this.isFiltered = false,
  });
}

class FilterTaskList extends TaskEvent {
  final bool isFiltered;
  const FilterTaskList(this.isFiltered);
}

class DeleteCompletedTasks extends TaskEvent {}
