import 'package:bloc/bloc.dart';
import 'package:test_app/blocs/task_details_event.dart';
import 'package:test_app/blocs/task_details_state.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/models/task_step.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc(TaskDetailsState initialState) : super(initialState);

  @override
  Stream<TaskDetailsState> mapEventToState(TaskDetailsEvent event) async* {
    if (event is FetchTask) {
      var task = event.task;
      yield TaskDetailsLoaded(task: task);
    }
    if (event is CreateStep) {
      _createStep(event.task, event.title);
      var task = event.task;
      yield TaskDetailsLoaded(task: task);
    }
    if (event is DeleteStep) {
      _deleteStep(event.task, event.index);
      var task = event.task;
      yield TaskDetailsLoaded(task: task);
    }
    if (event is SetDeadline) {
      _setDeadline(event.task, event.deadline);
      var task = event.task;
      yield TaskDetailsLoaded(task: task);
    }
    if (event is ChangeTaskTitle) {
      _changeTitle(event.task, event.title);
      var task = event.task;
      yield TaskDetailsLoaded(task: task);
    }
  }

  void _createStep(Task task, String title) {
    var lastStepId = task.steps.isEmpty ? 0 : task.steps.last.id;
    task.steps.add(TaskStep(++lastStepId, title, false));
    task.maxSteps = task.steps.length;
  }

  void _deleteStep(Task task, int index) {
    task.steps.removeAt(index);
    task.maxSteps = task.steps.length;
    task.completedSteps =
        task.steps.where((TaskStep element) => element.isComplete).length;
  }

  void _setDeadline(Task task, DateTime deadline) {
    task.deadline = deadline;
  }

  void _changeTitle(Task task, String title) {
    task.title = title;
  }
}
