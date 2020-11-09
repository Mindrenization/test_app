import 'package:test_app/models/task_step.dart';

class Task {
  final int id;
  String title;
  String description;
  bool isComplete;
  int completedSteps;
  int maxSteps;
  final DateTime createDate = DateTime.now();
  DateTime deadline;
  List<TaskStep> steps = [];

  Task(
    this.id,
    this.title, {
    this.deadline,
    this.isComplete = false,
    this.completedSteps = 0,
    this.maxSteps = 0,
    this.description,
  });
}
