abstract class TaskEvent {
  const TaskEvent();
}

class FetchTaskList extends TaskEvent {
  final String branchId;
  const FetchTaskList(this.branchId);
}

class CreateTask extends TaskEvent {
  final String branchId;
  final String title;
  final DateTime deadline;
  final onRefresh;
  const CreateTask({this.branchId, this.title, this.deadline, this.onRefresh});
}

class UpdateTask extends TaskEvent {
  final String branchId;
  final String taskId;
  const UpdateTask({this.branchId, this.taskId});
}

class ChangeColorTheme extends TaskEvent {
  final String branchId;
  const ChangeColorTheme({this.branchId});
}

class DeleteTask extends TaskEvent {
  final String branchId;
  final String taskId;
  final bool isFiltered;
  final onRefresh;
  const DeleteTask(
      {this.branchId, this.taskId, this.isFiltered = false, this.onRefresh});
}

class CompleteTask extends TaskEvent {
  final String branchId;
  final String taskId;
  final bool isFiltered;
  final onRefresh;
  const CompleteTask(
      {this.branchId, this.taskId, this.isFiltered = false, this.onRefresh});
}

class FilterTaskList extends TaskEvent {
  final String branchId;
  final bool isFiltered;
  const FilterTaskList({this.isFiltered, this.branchId});
}

class DeleteCompletedTasks extends TaskEvent {
  final String branchId;
  final onRefresh;
  const DeleteCompletedTasks({this.branchId, this.onRefresh});
}
