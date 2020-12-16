import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/models/branch_theme.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:uuid/uuid.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/task_repository.dart';
import 'package:test_app/presentation/bloc/task_event.dart';
import 'package:test_app/presentation/bloc/task_state.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(this.branchId) : super(TaskLoading());
  final String branchId;
  BranchTheme branchTheme;
  DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  TaskRepository _taskRepository = TaskRepository(
    Repository.getInstance(),
    DbTaskWrapper(),
    DbFlickr(),
    NotificationService(),
  );

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTaskList) {
      yield* _mapFetchTaskListEventToState(event);
    } else if (event is CreateTask) {
      yield* _mapCreateTaskEventToState(event);
    } else if (event is ChangeColorTheme) {
      yield* _mapChangeColorThemeEventToState(event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskEventToState(event);
    } else if (event is CompleteTask) {
      yield* _mapCompleteTaskEventToState(event);
    } else if (event is FilterTaskList) {
      yield* _mapFilterTaskListEventToState(event);
    } else if (event is DeleteCompletedTasks) {
      yield* _mapDeleteCompletedTasksEventToState(event);
    }
  }

  Stream<TaskState> _mapFetchTaskListEventToState(FetchTaskList event) async* {
    List<Task> _taskList = Repository.getInstance().getTaskList(branchId);
    branchTheme = event.branchTheme;
    yield TaskLoaded(
      _taskList,
      branchTheme,
    );
  }

  Stream<TaskState> _mapCreateTaskEventToState(CreateTask event) async* {
    List<Task> _taskList = await _createTask(event.title, branchId, event.deadline, event.notification);
    yield UpdateMainPage();
    yield TaskLoaded(
      _taskList,
      branchTheme,
    );
  }

  Stream<TaskState> _mapChangeColorThemeEventToState(ChangeColorTheme event) async* {
    Branch _branch = Repository.getInstance().getBranch(branchId);
    _branch.indexColorTheme = event.index;
    branchTheme = _branch.branchTheme;
    await _dbBranchWrapper.updateBranch(_branch);
    List<Task> _taskList = Repository.getInstance().getTaskList(branchId);
    yield TaskLoaded(
      _taskList,
      branchTheme,
    );
  }

  Stream<TaskState> _mapDeleteTaskEventToState(DeleteTask event) async* {
    List<Task> _taskList = await _deleteTask(branchId, event.taskId, event.isFiltered);
    yield UpdateMainPage();
    yield TaskLoaded(
      _taskList,
      branchTheme,
      isFiltered: event.isFiltered,
    );
  }

  Stream<TaskState> _mapCompleteTaskEventToState(CompleteTask event) async* {
    List<Task> _taskList = await _completeTask(branchId, event.taskId, event.isFiltered);
    yield UpdateMainPage();
    yield TaskLoaded(
      _taskList,
      branchTheme,
      isFiltered: event.isFiltered,
    );
  }

  Stream<TaskState> _mapFilterTaskListEventToState(FilterTaskList event) async* {
    List<Task> taskList;
    bool _isFiltered = !event.isFiltered;
    if (!event.isFiltered) {
      taskList = Repository.getInstance().getTaskList(branchId).where((element) => !element.isComplete).toList();
    } else {
      taskList = Repository.getInstance().getTaskList(branchId);
    }
    yield TaskLoaded(
      taskList,
      branchTheme,
      isFiltered: _isFiltered,
    );
  }

  Stream<TaskState> _mapDeleteCompletedTasksEventToState(DeleteCompletedTasks event) async* {
    List<Task> _taskList = Repository.getInstance().getTaskList(branchId);
    await _taskRepository.deleteCompletedTasks(branchId);
    yield UpdateMainPage();
    yield TaskLoaded(
      _taskList,
      branchTheme,
      isFiltered: false,
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
      DateTime.now(),
      deadline,
      notification,
    );
    await _taskRepository.createTask(_task, branchId);
    List<Task> _taskList = Repository.getInstance().getTaskList(branchId);
    return _taskList;
  }

  Future<List<Task>> _deleteTask(String branchId, String taskId, bool isFiltered) async {
    await _taskRepository.deleteTask(branchId, taskId);
    List<Task> _taskList;
    if (isFiltered) {
      _taskList = Repository.getInstance().getTaskList(branchId).where((element) => !element.isComplete).toList();
    } else {
      _taskList = Repository.getInstance().getTaskList(branchId);
    }
    return _taskList;
  }

  Future<List<Task>> _completeTask(String branchId, String taskId, bool isFiltered) async {
    List<Task> _taskList = Repository.getInstance().getTaskList(branchId);
    Task _task = Repository.getInstance().getTask(branchId, taskId);
    _isComplete(_task);
    await _dbTaskWrapper.updateTask(_task);
    if (isFiltered) {
      _taskList = Repository.getInstance().getTaskList(branchId).where((element) => !element.isComplete).toList();
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
