import 'package:bloc/bloc.dart';
import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/repository/repository.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc(TaskDetailsState initialState) : super(initialState);
  DbStepWrapper _dbStepWrapper = DbStepWrapper();
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();

  @override
  Stream<TaskDetailsState> mapEventToState(TaskDetailsEvent event) async* {
    if (event is FetchTask) {
      Task _task = Repository.instance.getTask(event.branchId, event.taskId);
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is UpdateTask) {
      Task _task = Repository.instance.getTask(event.branchId, event.taskId);
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is CreateStep) {
      Task _task = await _createStep(event.branchId, event.taskId, event.title);
      event.onRefresh();
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is DeleteStep) {
      Task _task =
          await _deleteStep(event.branchId, event.taskId, event.stepId);
      event.onRefresh();
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is CompleteStep) {
      Task _task =
          await _completeStep(event.branchId, event.taskId, event.stepId);
      event.onRefresh();
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is SetDeadline) {
      Task _task = Repository.instance.getTask(event.branchId, event.taskId);
      _task.deadline = event.deadline;
      await _dbTaskWrapper.updateTask(_task);
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is ChangeTaskTitle) {
      Task _task = Repository.instance.getTask(event.branchId, event.taskId);
      _task.title = event.title;
      await _dbTaskWrapper.updateTask(_task);
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is SaveDescription) {
      Task _task = Repository.instance.getTask(event.branchId, event.taskId);
      _task.description = event.text;
      await _dbTaskWrapper.updateTask(_task);
      yield TaskDetailsLoaded(task: _task);
    }
  }

  Future<Task> _createStep(String branchId, String taskId, String title) async {
    Task _task = Repository.instance.getTask(branchId, taskId);
    TaskStep _step = TaskStep(title, id: Uuid().v1(), parentId: taskId);
    await _dbStepWrapper.createStep(_step);
    _task.steps.add(_step);
    return _task;
  }

  Future<Task> _deleteStep(
      String branchId, String taskId, String stepId) async {
    Task _task = Repository.instance.getTask(
      branchId,
      taskId,
    );
    TaskStep _step = Repository.instance.getStep(branchId, taskId, stepId);
    await _dbStepWrapper.deleteStep(_step);
    _task.steps.removeWhere((element) => _step.id == element.id);
    return _task;
  }

  Future<Task> _completeStep(branchId, taskId, stepId) async {
    Task _task = Repository.instance.getTask(branchId, taskId);
    TaskStep _step = Repository.instance.getStep(branchId, taskId, stepId);
    if (_step.isComplete) {
      _step.isComplete = false;
    } else {
      _step.isComplete = true;
    }
    await _dbStepWrapper.updateStep(_step);
    return _task;
  }
}
