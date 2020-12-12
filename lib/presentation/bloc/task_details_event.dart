abstract class TaskDetailsEvent {
  const TaskDetailsEvent();
}

class FetchTask extends TaskDetailsEvent {
  const FetchTask();
}

class UpdateTask extends TaskDetailsEvent {
  const UpdateTask();
}

class CreateStep extends TaskDetailsEvent {
  final String title;
  const CreateStep(this.title);
}

class DeleteStep extends TaskDetailsEvent {
  final String stepId;
  const DeleteStep(this.stepId);
}

class CompleteStep extends TaskDetailsEvent {
  final String stepId;
  CompleteStep(this.stepId);
}

class SetDeadline extends TaskDetailsEvent {
  final DateTime deadline;
  const SetDeadline(this.deadline);
}

class SetNotification extends TaskDetailsEvent {
  final DateTime notification;
  const SetNotification(this.notification);
}

class DeleteDeadline extends TaskDetailsEvent {
  const DeleteDeadline();
}

class DeleteNotification extends TaskDetailsEvent {
  const DeleteNotification();
}

class ChangeTaskTitle extends TaskDetailsEvent {
  final String title;
  const ChangeTaskTitle(this.title);
}

class SaveDescription extends TaskDetailsEvent {
  final String text;
  const SaveDescription(this.text);
}

class DeleteImage extends TaskDetailsEvent {
  final String imageId;
  const DeleteImage(this.imageId);
}

class SaveImage extends TaskDetailsEvent {
  final String imageUrl;
  const SaveImage({
    this.imageUrl,
  });
}
