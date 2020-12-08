import 'package:test_app/data/models/task_step.dart';

class Task {
  final String id;
  final String parentId;
  String title;
  String description;
  bool isComplete;
  int completedSteps;
  int maxSteps;
  DateTime createDate = DateTime.now();
  DateTime deadline;
  List<TaskStep> steps = [];

  Task(this.id, this.parentId, this.title,
      {this.deadline,
      this.isComplete = false,
      this.completedSteps = 0,
      this.maxSteps = 0,
      this.description,
      this.createDate});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'parentID': parentId,
      'title': title,
      'complete': isComplete.toString(),
      'description': description,
      'createDate': createDate.millisecondsSinceEpoch,
      if (deadline != null) 'deadline': deadline.millisecondsSinceEpoch,
    };
  }
}
