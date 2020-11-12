import 'dart:async';
import 'package:test_app/blocs/bloc.dart';
import 'package:test_app/models/task_step.dart';

class StepBloc extends Bloc {
  StreamController _controller = StreamController.broadcast();

  Stream get getSteps => _controller.stream;

  createStep(task, String title) {
    var lastStepId = task.steps.isEmpty ? 0 : task.steps.last.id;
    task.steps.add(TaskStep(++lastStepId, title, false));
    task.maxSteps = task.steps.length;

    _controller.sink.add(task.steps);
  }

  updateSteps(stepList) {
    _controller.sink.add(stepList);
  }

  deleteStep(task, index) {
    task.steps.removeAt(index);
    task.maxSteps = task.steps.length;
    task.completedSteps =
        task.steps.where((TaskStep element) => element.isComplete).length;
    _controller.sink.add(task.steps);
  }

  isComplete(task, index, value) {
    task.steps[index].isComplete = value;
    task.completedSteps =
        task.steps.where((TaskStep element) => element.isComplete).length;
    _controller.sink.add(task.steps);
  }

  dispose() {
    _controller.close();
  }
}
