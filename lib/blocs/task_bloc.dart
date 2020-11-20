import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:test_app/blocs/task_event.dart';
import 'package:test_app/blocs/task_state.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/models/task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(TaskState initialState) : super(initialState);

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTaskList) {
      var branch = event.branch;
      yield TaskLoaded(branch: branch);
    }
    if (event is CreateTask) {
      _createTask(event.branch, event.title, event.deadline);
      var branch = event.branch;
      yield TaskLoaded(branch: branch);
    }
    if (event is DeleteTask) {
      _deleteTask(event.branch, event.index, event.isFiltered);
      var branch = event.branch;
      yield TaskLoaded(branch: branch, isFiltered: event.isFiltered);
    }
    if (event is CompleteTask) {
      _isComplete(event.task);
      var branch = event.branch;
      yield TaskLoaded(branch: branch);
    }
    if (event is FilterTaskList) {
      var isFiltered = _filterTasks(event.branch, event.isFiltered);
      var branch = event.branch;
      yield TaskLoaded(branch: branch, isFiltered: isFiltered);
    }
    if (event is DeletedCompletedTasks) {
      var isFiltered = _deleteCompletedTasks(event.branch);
      var branch = event.branch;
      yield TaskLoaded(branch: branch, isFiltered: isFiltered);
    }
  }

  void _createTask(Branch branch, String title, DateTime deadline) {
    var lastTaskId = branch.tasks.isEmpty ? 0 : branch.tasks.last.id;
    branch.tasks.add(
      Task(++lastTaskId, title, deadline: deadline),
    );
  }

  void _deleteTask(Branch branch, int index, bool isFiltered) {
    var task = isFiltered ? branch.filteredTasks[index] : branch.tasks[index];
    branch.tasks.removeWhere((element) => element.id == task.id);
    if (isFiltered) {
      branch.filteredTasks.removeWhere((element) => element.id == task.id);
    }
  }

  void _isComplete(Task task) {
    if (task.isComplete) {
      task.isComplete = false;
    } else {
      task.isComplete = true;
    }
  }

  bool _filterTasks(Branch branch, bool isFiltered) {
    if (!isFiltered) {
      if (branch.tasks.any((task) => task.isComplete)) {
        branch.filteredTasks =
            branch.tasks.where((task) => !task.isComplete).toList();
        return isFiltered = true;
      } else {
        return isFiltered = false;
      }
    } else {
      return isFiltered = false;
    }
  }

  bool _deleteCompletedTasks(Branch branch) {
    branch.tasks.removeWhere((task) => task.isComplete);
    return false;
  }
}
