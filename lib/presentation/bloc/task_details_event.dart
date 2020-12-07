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
  const CreateStep({this.title, this.taskId, this.branchId});
}

class DeleteStep extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String stepId;

  const DeleteStep({this.branchId, this.taskId, this.stepId});
}

class CompleteStep extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String stepId;
  CompleteStep({this.branchId, this.taskId, this.stepId});
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

class DeleteImage extends TaskDetailsEvent {
  final String branchId;
  final String taskId;
  final String imageId;
  const DeleteImage({this.branchId, this.taskId, this.imageId});
}
