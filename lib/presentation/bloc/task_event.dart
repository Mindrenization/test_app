abstract class TaskEvent {
  final String branchId;
  const TaskEvent(this.branchId);
}

class FetchTaskList extends TaskEvent {
  const FetchTaskList(branchId) : super(branchId);
}

class CreateTask extends TaskEvent {
  final String title;
  final DateTime deadline;
  const CreateTask({branchId, this.title, this.deadline}) : super(branchId);
}

class UpdateTask extends TaskEvent {
  final String taskId;
  const UpdateTask({branchId, this.taskId}) : super(branchId);
}

class ChangeColorTheme extends TaskEvent {
  const ChangeColorTheme({branchId}) : super(branchId);
}

class DeleteTask extends TaskEvent {
  final String taskId;
  final bool isFiltered;
  const DeleteTask({branchId, this.taskId, this.isFiltered = false})
      : super(branchId);
}

class CompleteTask extends TaskEvent {
  final String taskId;
  final bool isFiltered;
  const CompleteTask({branchId, this.taskId, this.isFiltered = false})
      : super(branchId);
}

class FilterTaskList extends TaskEvent {
  final bool isFiltered;
  const FilterTaskList({branchId, this.isFiltered}) : super(branchId);
}

class DeleteCompletedTasks extends TaskEvent {
  const DeleteCompletedTasks({branchId}) : super(branchId);
}
