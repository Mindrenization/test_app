class Task {
  final int id;
  final String title;
  bool isComplete;
  final int currentStep;
  final int maxSteps;

  Task(this.id, this.title, this.isComplete, this.currentStep, this.maxSteps);
}
