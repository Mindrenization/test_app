abstract class TaskDetailsEvent {
  const TaskDetailsEvent();
}

class FetchTask extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  const FetchTask({this.taskId, this.branchId});
}

class UpdateTask extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  const UpdateTask({this.taskId, this.branchId});
}

class CreateStep extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String title;
  final onRefresh;
  const CreateStep({this.title, this.taskId, this.branchId, this.onRefresh});
}

class DeleteStep extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String stepId;
  final onRefresh;
  const DeleteStep({this.branchId, this.taskId, this.stepId, this.onRefresh});
}

class CompleteStep extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String stepId;
  final onRefresh;
  CompleteStep({this.branchId, this.taskId, this.stepId, this.onRefresh});
}

class SetDeadline extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final DateTime deadline;
  const SetDeadline({this.taskId, this.branchId, this.deadline});
}

class ChangeTaskTitle extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String title;
  const ChangeTaskTitle({this.branchId, this.taskId, this.title});
}

class SaveDescription extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String text;
  const SaveDescription({this.branchId, this.taskId, this.text});
}
