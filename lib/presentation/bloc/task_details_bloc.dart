import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:test_app/data/database/db_flickr.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/step_repository.dart';
import 'package:test_app/data/repository/task_repository.dart';
import 'package:test_app/presentation/bloc/task_details_event.dart';
import 'package:test_app/presentation/bloc/task_details_state.dart';
import 'package:test_app/data/repository/repository.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc(this.branchId, this.taskId) : super(TaskDetailsLoading());
  final String branchId;
  final String taskId;
  DbStepWrapper _dbStepWrapper = DbStepWrapper();
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  StepRepository _stepRepository = StepRepository(Repository.getInstance(), DbStepWrapper());
  TaskRepository _taskRepository = TaskRepository(
    Repository.getInstance(),
    DbTaskWrapper(),
    DbFlickr(),
    NotificationService(),
  );

  @override
  Stream<TaskDetailsState> mapEventToState(TaskDetailsEvent event) async* {
    if (event is FetchTask) {
      yield* _mapFetchTaskEventToState(event);
    } else if (event is CreateStep) {
      yield* _mapCreateStepEventToState(event);
    } else if (event is DeleteStep) {
      yield* _mapDeleteStepEventToState(event);
    } else if (event is DeleteImage) {
      yield* _mapDeleteImageEventToState(event);
    } else if (event is CompleteStep) {
      yield* _mapCompleteStepEventToState(event);
    } else if (event is SetDeadline) {
      yield* _mapSetDeadlineEventToState(event);
    } else if (event is SetNotification) {
      yield* _mapSetNotificationEventToState(event);
    } else if (event is DeleteDeadline) {
      yield* _mapDeleteDeadlineEventToState(event);
    } else if (event is DeleteNotification) {
      yield* _mapDeleteNotificationEventToState(event);
    } else if (event is ChangeTaskTitle) {
      yield* _mapChangeTaskTitleEventToState(event);
    } else if (event is SaveDescription) {
      yield* _mapSaveDescriptionEventToState(event);
    } else if (event is SaveImage) {
      yield* _mapSaveImageEventToState(event);
    }
  }

  Stream<TaskDetailsState> _mapFetchTaskEventToState(FetchTask event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapCreateStepEventToState(CreateStep event) async* {
    Task _task = await _createStep(branchId, taskId, event.title);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapDeleteStepEventToState(DeleteStep event) async* {
    Task _task = await _deleteStep(branchId, taskId, event.stepId);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapDeleteImageEventToState(DeleteImage event) async* {
    Task _task = await _deleteImage(branchId, taskId, event.imageId);
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapCompleteStepEventToState(CompleteStep event) async* {
    Task _task = await _completeStep(branchId, taskId, event.stepId);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapSetDeadlineEventToState(SetDeadline event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    _task.deadline = event.deadline;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapSetNotificationEventToState(SetNotification event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    if (_task.notification != null) {
      await NotificationService().cancelNotification(_task);
    }
    if (event.notification != null) {
      _task.notification = event.notification;
      await NotificationService().scheduleNotification(_task);
      await _dbTaskWrapper.updateTask(_task);
    }
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapDeleteDeadlineEventToState(DeleteDeadline event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    _task.deadline = null;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapDeleteNotificationEventToState(DeleteNotification event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    await NotificationService().cancelNotification(_task);
    _task.notification = null;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapChangeTaskTitleEventToState(ChangeTaskTitle event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    _task.title = event.title;
    await _dbTaskWrapper.updateTask(_task);
    yield UpdateTasksPage();
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapSaveDescriptionEventToState(SaveDescription event) async* {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    _task.description = event.text;
    await _dbTaskWrapper.updateTask(_task);
    yield TaskDetailsLoaded(_task);
  }

  Stream<TaskDetailsState> _mapSaveImageEventToState(SaveImage event) async* {
    File _file = await DefaultCacheManager().getSingleFile(event.imageUrl);
    FlickrImage _image = FlickrImage(Uuid().v1(), taskId, _file.path);
    await _taskRepository.saveImage(branchId, taskId, _image);
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    yield TaskDetailsLoaded(_task);
  }

  Future<Task> _createStep(String branchId, String taskId, String title) async {
    TaskStep _step = TaskStep(title, id: Uuid().v1(), parentId: taskId);
    await _stepRepository.createStep(branchId, taskId, _step);
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    return _task;
  }

  Future<Task> _deleteStep(String branchId, String taskId, String stepId) async {
    await _stepRepository.deleteStep(branchId, taskId, stepId);
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    return _task;
  }

  Future<Task> _deleteImage(String branchId, String taskId, String imageId) async {
    await _taskRepository.deleteImage(branchId, taskId, imageId);
    Task _task = Repository.getInstance().getTask(
      branchId,
      taskId,
    );
    return _task;
  }

  Future<Task> _completeStep(String branchId, String taskId, String stepId) async {
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    TaskStep _step = Repository.getInstance().getStep(branchId, taskId, stepId);
    if (_step.isComplete) {
      _step.isComplete = false;
    } else {
      _step.isComplete = true;
    }
    await _dbStepWrapper.updateStep(_step);
    return _task;
  }
}
