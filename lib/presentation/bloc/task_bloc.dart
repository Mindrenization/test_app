import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/task_repository.dart';
import 'package:test_app/presentation/bloc/task_event.dart';
import 'package:test_app/presentation/bloc/task_state.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(TaskState initialState, this.branchId, this.mainColor, this.backgroundColor) : super(initialState);
  final String branchId;
  Color mainColor;
  Color backgroundColor;
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  TaskRepository _taskRepository = TaskRepository();

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTaskList) yield* _mapFetchTaskListEventToState(event);
    if (event is CreateTask) yield* _mapCreateTaskEventToState(event);
    if (event is ChangeColorTheme) yield* _mapChangeColorThemeEventToState(event);
    if (event is UpdateTask) yield* _mapUpdateTaskEventToState(event);
    if (event is DeleteTask) yield* _mapDeleteTaskEventToState(event);
    if (event is CompleteTask) yield* _mapCompleteTaskEventToState(event);
    if (event is FilterTaskList) yield* _mapFilterTaskListEventToState(event);
    if (event is DeleteCompletedTasks) yield* _mapDeleteCompletedTasksEventToState(event);
  }

  Stream<TaskState> _mapFetchTaskListEventToState(FetchTaskList event) async* {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    yield TaskLoaded(
      taskList: _taskList,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapCreateTaskEventToState(CreateTask event) async* {
    List<Task> _taskList = await _createTask(event.title, branchId, event.deadline, event.notification);
    yield UpdateMainPage();
    yield TaskLoaded(
      taskList: _taskList,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapChangeColorThemeEventToState(ChangeColorTheme event) async* {
    Branch _branch = Repository.instance.getBranch(branchId);
    _branch.mainColor = event.mainColor;
    _branch.backgroundColor = event.backgroundColor;
    mainColor = event.mainColor;
    backgroundColor = event.backgroundColor;
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    yield TaskLoaded(
      taskList: _taskList,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapUpdateTaskEventToState(UpdateTask event) async* {
    List<Task> _taskList = _updateTask(branchId, event.taskId);
    yield TaskLoaded(
      taskList: _taskList,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapDeleteTaskEventToState(DeleteTask event) async* {
    List<Task> _taskList = await _deleteTask(branchId, event.taskId, event.isFiltered);
    yield UpdateMainPage();
    yield TaskLoaded(
      taskList: _taskList,
      isFiltered: event.isFiltered,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapCompleteTaskEventToState(CompleteTask event) async* {
    List<Task> _taskList = await _completeTask(branchId, event.taskId, event.isFiltered);
    yield UpdateMainPage();
    yield TaskLoaded(
      taskList: _taskList,
      isFiltered: event.isFiltered,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapFilterTaskListEventToState(FilterTaskList event) async* {
    List<Task> taskList;
    bool _isFiltered;
    if (!event.isFiltered) {
      if (Repository.instance.getTaskList(branchId).any((task) => task.isComplete)) {
        taskList = Repository.instance.getTaskList(branchId).where((element) => !element.isComplete).toList();
        _isFiltered = true;
      } else {
        taskList = Repository.instance.getTaskList(branchId);
        _isFiltered = false;
      }
    } else {
      taskList = Repository.instance.getTaskList(branchId);
      _isFiltered = false;
    }
    yield TaskLoaded(
      taskList: taskList,
      isFiltered: _isFiltered,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Stream<TaskState> _mapDeleteCompletedTasksEventToState(DeleteCompletedTasks event) async* {
    List<Task> _taskList = await _taskRepository.deleteCompletedTasks(branchId);
    yield UpdateMainPage();
    yield TaskLoaded(
      taskList: _taskList,
      isFiltered: false,
      mainColor: mainColor,
      backgroundColor: backgroundColor,
    );
  }

  Future<List<Task>> _createTask(
    String title,
    String branchId,
    DateTime deadline,
    DateTime notification,
  ) async {
    Task _task = Task(
      Uuid().v1(),
      branchId,
      title,
      deadline: deadline,
      notification: notification,
      createDate: DateTime.now(),
    );
    List<Task> _taskList = await _taskRepository.createTask(_task, branchId);
    return _taskList;
  }

  List<Task> _updateTask(String branchId, String taskId) {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    Task _task = Repository.instance.getTask(branchId, taskId);
    _task.maxSteps = _task.steps.length;
    _task.completedSteps = _task.steps.where((element) => element.isComplete).length;
    return _taskList;
  }

  Future<List<Task>> _deleteTask(String branchId, String taskId, bool isFiltered) async {
    List<Task> _taskList = await _taskRepository.deleteTask(branchId, taskId);
    if (isFiltered) {
      _taskList = Repository.instance.getTaskList(branchId).where((element) => !element.isComplete).toList();
    }
    return _taskList;
  }

  Future<List<Task>> _completeTask(String branchId, String taskId, bool isFiltered) async {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    Task _task = Repository.instance.getTask(branchId, taskId);
    _isComplete(_task);
    await _dbTaskWrapper.updateTask(_task);
    if (isFiltered) {
      _taskList = Repository.instance.getTaskList(branchId).where((element) => !element.isComplete).toList();
    }
    return _taskList;
  }

  void _isComplete(Task _task) {
    if (_task.isComplete) {
      _task.isComplete = false;
    } else {
      _task.isComplete = true;
    }
  }
}
