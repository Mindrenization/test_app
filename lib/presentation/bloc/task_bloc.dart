import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:test_app/data/repository/task_repository.dart';
import 'package:test_app/presentation/bloc/task_event.dart';
import 'package:test_app/presentation/bloc/task_state.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(TaskState initialState) : super(initialState);
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  TaskInteractor _taskInteractor = TaskInteractor();

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTaskList) {
      List<Task> _taskList = Repository.instance.getTaskList(event.branchId);
      yield TaskLoaded(taskList: _taskList);
    }
    if (event is CreateTask) {
      List<Task> _taskList = await _createTask(
          event.title, event.branchId, event.deadline, event.notification);
      yield TaskLoaded(taskList: _taskList);
    }
    if (event is ChangeColorTheme) {
      List<Task> _taskList = Repository.instance.getTaskList(event.branchId);
      yield TaskLoaded(taskList: _taskList);
    }
    if (event is UpdateTask) {
      List<Task> _taskList = _updateTask(event.branchId, event.taskId);
      yield TaskLoaded(taskList: _taskList);
    }
    if (event is DeleteTask) {
      List<Task> _taskList =
          await _deleteTask(event.branchId, event.taskId, event.isFiltered);
      yield TaskLoaded(taskList: _taskList, isFiltered: event.isFiltered);
    }
    if (event is CompleteTask) {
      List<Task> _taskList =
          await _completeTask(event.branchId, event.taskId, event.isFiltered);
      yield TaskLoaded(taskList: _taskList, isFiltered: event.isFiltered);
    }
    if (event is FilterTaskList) {
      List<Task> taskList;
      bool _isFiltered;
      if (!event.isFiltered) {
        if (Repository.instance
            .getTaskList(event.branchId)
            .any((task) => task.isComplete)) {
          taskList = Repository.instance
              .getTaskList(event.branchId)
              .where((element) => !element.isComplete)
              .toList();
          _isFiltered = true;
        } else {
          taskList = Repository.instance.getTaskList(event.branchId);
          _isFiltered = false;
        }
      } else {
        taskList = Repository.instance.getTaskList(event.branchId);
        _isFiltered = false;
      }
      yield TaskLoaded(
        taskList: taskList,
        isFiltered: _isFiltered,
      );
    }
    if (event is DeleteCompletedTasks) {
      List<Task> _taskList = await _deleteCompletedTasks(event.branchId);
      yield TaskLoaded(taskList: _taskList, isFiltered: false);
    }
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
    List<Task> _taskList = await _taskInteractor.createTask(_task, branchId);
    return _taskList;
  }

  List<Task> _updateTask(String branchId, String taskId) {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    Task _task = Repository.instance.getTask(branchId, taskId);
    _task.maxSteps = _task.steps.length;
    _task.completedSteps =
        _task.steps.where((element) => element.isComplete).length;
    return _taskList;
  }

  Future<List<Task>> _deleteTask(
      String branchId, String taskId, bool isFiltered) async {
    List<Task> _taskList = await _taskInteractor.deleteTask(branchId, taskId);
    if (isFiltered) {
      _taskList = Repository.instance
          .getTaskList(branchId)
          .where((element) => !element.isComplete)
          .toList();
    }
    return _taskList;
  }

  Future<List<Task>> _completeTask(
      String branchId, String taskId, bool isFiltered) async {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    Task _task = Repository.instance.getTask(branchId, taskId);
    _isComplete(_task);
    await _dbTaskWrapper.updateTask(_task);
    if (isFiltered) {
      _taskList = Repository.instance
          .getTaskList(branchId)
          .where((element) => !element.isComplete)
          .toList();
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

  Future<List<Task>> _deleteCompletedTasks(branchId) async {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    List<Task> _completedTasks =
        _taskList.where((task) => task.isComplete).toList();
    for (int i = 0; i < _completedTasks.length; i++) {
      await _dbTaskWrapper.deleteAllSteps(_completedTasks[i]);
    }
    _taskList.removeWhere((task) => task.isComplete);
    await _dbTaskWrapper.deleteCompletedTasks(branchId);
    return _taskList;
  }
}
