import 'package:test_app/models/task_step.dart';

class Task {
  final int id;
  String title;
  bool isComplete;
  int currentStep;
  int maxSteps;
  List<TaskStep> steps = [];

  Task(this.id, this.title, this.isComplete, this.currentStep, this.maxSteps);
}
