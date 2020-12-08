abstract class TaskDetailsEvent {
  final String branchId;
  final String taskId;
  const TaskDetailsEvent(this.branchId, this.taskId);
}

class FetchTask extends TaskDetailsEvent {
  const FetchTask({branchId, taskId}) : super(branchId, taskId);
}

class UpdateTask extends TaskDetailsEvent {
  const UpdateTask({branchId, taskId}) : super(branchId, taskId);
}

class CreateStep extends TaskDetailsEvent {
  final String title;
  const CreateStep({this.title, taskId, branchId}) : super(branchId, taskId);
}

class DeleteStep extends TaskDetailsEvent {
  final String stepId;
  const DeleteStep({branchId, taskId, this.stepId}) : super(branchId, taskId);
}

class CompleteStep extends TaskDetailsEvent {
  final String stepId;
  CompleteStep({branchId, taskId, this.stepId}) : super(branchId, taskId);
}

class SetDeadline extends TaskDetailsEvent {
  final DateTime deadline;
  const SetDeadline({taskId, branchId, this.deadline})
      : super(branchId, taskId);
}

class ChangeTaskTitle extends TaskDetailsEvent {
  final String title;
  const ChangeTaskTitle({branchId, taskId, this.title})
      : super(branchId, taskId);
}

class SaveDescription extends TaskDetailsEvent {
  final String text;
  const SaveDescription({branchId, taskId, this.text})
      : super(branchId, taskId);
}

class DeleteImage extends TaskDetailsEvent {
  final String imageId;
  const DeleteImage({branchId, taskId, this.imageId}) : super(branchId, taskId);
}
