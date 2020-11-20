import 'package:test_app/models/branch.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class FetchTaskList extends TaskEvent {
  final Branch branch;
  const FetchTaskList(this.branch);
}

class CreateTask extends TaskEvent {
  final Branch branch;
  final String title;
  final deadline;
  const CreateTask({this.branch, this.title, this.deadline});
}

class DeleteTask extends TaskEvent {
  final branch;
  final int index;
  final isFiltered;
  const DeleteTask({this.branch, this.index, this.isFiltered});
}

class CompleteTask extends TaskEvent {
  final task;
  final branch;
  const CompleteTask({this.task, this.branch});
}

class FilterTaskList extends TaskEvent {
  final Branch branch;
  final bool isFiltered;
  const FilterTaskList(this.branch, {this.isFiltered});
}

class DeletedCompletedTasks extends TaskEvent {
  final Branch branch;

  const DeletedCompletedTasks(this.branch);
}
