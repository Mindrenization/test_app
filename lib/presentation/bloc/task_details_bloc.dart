import 'package:bloc/bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/step_repository.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc(TaskDetailsState initialState, this.branchId, this.taskId) : super(initialState);
  final String branchId;
  final String taskId;
  DbStepWrapper _dbStepWrapper = DbStepWrapper();
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  StepRepository _stepRepository = StepRepository();
  DbFlickr _dbFlickr = DbFlickr();

  @override
  Stream<TaskDetailsState> mapEventToState(TaskDetailsEvent event) async* {
    if (event is FetchTask) yield* _mapFetchTaskEventToState(event);
    if (event is UpdateTask) yield* _mapUpdateTaskEventToState(event);
    if (event is CreateStep) yield* _mapCreateStepEventToState(event);
    if (event is DeleteStep) yield* _mapDeleteStepEventToState(event);
    if (event is DeleteImage) yield* _mapDeleteImageEventToState(event);
    if (event is CompleteStep) yield* _mapCompleteStepEventToState(event);
    if (event is SetDeadline) yield* _mapSetDeadlineEventToState(event);
    if (event is SetNotification) yield* _mapSetNotificationEventToState(event);
    if (event is DeleteDeadline) yield* _mapDeleteDeadlineEventToState(event);
    if (event is DeleteNotification) yield* _mapDeleteNotificationEventToState(event);
    if (event is ChangeTaskTitle) yield* _mapChangeTaskTitleEventToState(event);
    if (event is SaveDescription) yield* _mapSaveDescriptionEventToState(event);
    if (event is SaveImage) yield* _mapSaveImageEventToState(event);
  }

  Stream<TaskDetailsState> _mapFetchTaskEventToState(FetchTask event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapUpdateTaskEventToState(UpdateTask event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapCreateStepEventToState(CreateStep event) async* {
    Task _task = await _createStep(branchId, taskId, event.title);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapDeleteStepEventToState(DeleteStep event) async* {
    Task _task = await _deleteStep(branchId, taskId, event.stepId);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapDeleteImageEventToState(DeleteImage event) async* {
    Task _task = await _deleteImage(branchId, taskId, event.imageId);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapCompleteStepEventToState(CompleteStep event) async* {
    Task _task = await _completeStep(branchId, taskId, event.stepId);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapSetDeadlineEventToState(SetDeadline event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    _task.deadline = event.deadline;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapSetNotificationEventToState(SetNotification event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    if (_task.notification != null) {
      await NotificationService().cancelNotification(_task);
    }
    if (event.notification != null) {
      _task.notification = event.notification;
      await NotificationService().scheduleNotification(_task);
      await _dbTaskWrapper.updateTask(_task);
    }
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapDeleteDeadlineEventToState(DeleteDeadline event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    _task.deadline = null;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapDeleteNotificationEventToState(DeleteNotification event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    await NotificationService().cancelNotification(_task);
    _task.notification = null;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapChangeTaskTitleEventToState(ChangeTaskTitle event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    _task.title = event.title;
    await _dbTaskWrapper.updateTask(_task);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapSaveDescriptionEventToState(SaveDescription event) async* {
    Task _task = Repository.instance.getTask(branchId, taskId);
    _task.description = event.text;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(task: _task);
  }

  Stream<TaskDetailsState> _mapSaveImageEventToState(SaveImage event) async* {
    var _file = await DefaultCacheManager().getSingleFile(event.imageUrl);
    Task _task = Repository.instance.getTask(branchId, taskId);
    FlickrImage _newImage = FlickrImage(Uuid().v1(), taskId, _file.path);
    _task.images.add(_newImage);
    _dbFlickr.saveImage(_newImage);
    yield TaskDetailsLoaded(task: _task);
  }

  Future<Task> _createStep(String _branchId, String _taskId, String _title) async {
    TaskStep _step = TaskStep(_title, id: Uuid().v1(), parentId: _taskId);
    Task _task = await _stepRepository.createStep(_branchId, _taskId, _step);
    return _task;
  }

  Future<Task> _deleteStep(String _branchId, String _taskId, String _stepId) async {
    Task _task = await _stepRepository.deleteStep(_branchId, _taskId, _stepId);
    return _task;
  }

  Future<Task> _deleteImage(String branchId, String taskId, String imageId) async {
    Task _task = Repository.instance.getTask(
      branchId,
      taskId,
    );
    FlickrImage _image = Repository.instance.getImage(branchId, taskId, imageId);
    await _dbTaskWrapper.deleteImage(_image.id);
    _task.images.removeWhere((element) => _image.id == element.id);
    return _task;
  }

  Future<Task> _completeStep(String branchId, String taskId, String stepId) async {
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
