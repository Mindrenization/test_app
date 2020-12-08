import 'package:bloc/bloc.dart';
import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/repository/step_repository.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc(TaskDetailsState initialState) : super(initialState);
  DbStepWrapper _dbStepWrapper = DbStepWrapper();
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  StepInteractor _stepInteractor = StepInteractor();

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
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is DeleteStep) {
      Task _task =
          await _deleteStep(event.branchId, event.taskId, event.stepId);
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is DeleteImage) {
      Task _task =
          await _deleteImage(event.branchId, event.taskId, event.imageId);
      yield TaskDetailsLoaded(task: _task);
    }
    if (event is CompleteStep) {
      Task _task =
          await _completeStep(event.branchId, event.taskId, event.stepId);
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

  Future<Task> _createStep(
      String _branchId, String _taskId, String _title) async {
    TaskStep _step = TaskStep(_title, id: Uuid().v1(), parentId: _taskId);
    Task _task = await _stepInteractor.createStep(_branchId, _taskId, _step);
    return _task;
  }

  Future<Task> _deleteStep(
      String _branchId, String _taskId, String _stepId) async {
    Task _task = await _stepInteractor.deleteStep(_branchId, _taskId, _stepId);
    return _task;
  }

  Future<Task> _deleteImage(branchId, taskId, imageId) async {
    Task _task = Repository.instance.getTask(
      branchId,
      taskId,
    );
    Image _image = Repository.instance.getImage(branchId, taskId, imageId);
    await _dbTaskWrapper.deleteImage(_image.id);
    _task.images.removeWhere((element) => _image.id == element.id);
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
