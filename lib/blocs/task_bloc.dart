import 'dart:async';
import 'package:test_app/blocs/bloc.dart';
import 'package:test_app/models/task.dart';

class TaskBloc extends Bloc {
  StreamController<List<Task>> _controller = StreamController.broadcast();

  Stream<List<Task>> get getTasks => _controller.stream;

  void createTask(List<Task> taskList, title, deadline) {
    var lastTaskId = taskList.isEmpty ? 0 : taskList.last.id;
    taskList.add(
      Task(++lastTaskId, title, deadline: deadline),
    );
    _controller.sink.add(taskList);
  }

  void updateTasks(List<Task> taskList) {
    _controller.sink.add(taskList);
  }

  void deleteTask(List<Task> taskList, int index, bool isFiltered,
      List<Task> filteredTaskList) {
    var task = isFiltered ? filteredTaskList[index] : taskList[index];
    taskList.removeWhere((element) => element.id == task.id);
    if (isFiltered) {
      filteredTaskList.removeWhere((element) => element.id == task.id);
    }
    _controller.sink.add(taskList);
  }

  bool filterTasks(
      List<Task> taskList, List<Task> filteredTaskList, bool isFiltered) {
    if (!isFiltered) {
      if (taskList.any((task) => task.isComplete)) {
        filteredTaskList = taskList.where((task) => !task.isComplete).toList();
        _controller.sink.add(filteredTaskList);
        return isFiltered = true;
      } else {
        return isFiltered = false;
      }
    } else {
      _controller.sink.add(taskList);
      return isFiltered = false;
    }
  }

  void deleteCompletedTasks(List<Task> taskList) {
    taskList.removeWhere((task) => task.isComplete);
    _controller.sink.add(taskList);
  }

  dispose() {
    _controller.close();
  }
}
