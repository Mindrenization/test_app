import 'dart:async';
import 'package:test_app/blocs/bloc.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/models/task_step.dart';

class TaskDetailsBloc extends Bloc {
  StreamController<Task> _controller = StreamController.broadcast();

  Stream get getSteps => _controller.stream;

  void createStep(Task task, String title) {
    var lastStepId = task.steps.isEmpty ? 0 : task.steps.last.id;
    task.steps.add(TaskStep(++lastStepId, title, false));
    task.maxSteps = task.steps.length;
    _controller.sink.add(task);
  }

  void updateSteps(Task task) {
    _controller.sink.add(task);
  }

  void deleteStep(Task task, int index) {
    task.steps.removeAt(index);
    task.maxSteps = task.steps.length;
    task.completedSteps =
        task.steps.where((TaskStep element) => element.isComplete).length;
    _controller.sink.add(task);
  }

  void isComplete(Task task, int index, value) {
    task.steps[index].isComplete = value;
    task.completedSteps =
        task.steps.where((TaskStep element) => element.isComplete).length;
    _controller.sink.add(task);
  }

  void setDeadline(Task task, DateTime deadline) {
    task.deadline = deadline;
    _controller.sink.add(task);
  }

  void changeTitle(Task task, String title) {
    task.title = title;
    _controller.sink.add(task);
  }

  void dispose() {
    _controller.close();
  }
}
