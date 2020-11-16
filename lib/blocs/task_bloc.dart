import 'dart:async';
import 'package:test_app/blocs/bloc.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/models/task.dart';

class TaskBloc extends Bloc {
  StreamController<Branch> _controller = StreamController.broadcast();

  Stream<Branch> get getBranch => _controller.stream;

  void createTask(Branch branch, String title, DateTime deadline) {
    var lastTaskId = branch.tasks.isEmpty ? 0 : branch.tasks.last.id;
    branch.tasks.add(
      Task(++lastTaskId, title, deadline: deadline),
    );
    _controller.sink.add(branch);
  }

  void updateTasks(Branch branch) {
    _controller.sink.add(branch);
  }

  void deleteTask(Branch branch, int index, bool isFiltered) {
    var task = isFiltered ? branch.filteredTasks[index] : branch.tasks[index];
    branch.tasks.removeWhere((element) => element.id == task.id);
    if (isFiltered) {
      branch.filteredTasks.removeWhere((element) => element.id == task.id);
    }
    _controller.sink.add(branch);
  }

  bool filterTasks(Branch branch, bool isFiltered) {
    if (!isFiltered) {
      if (branch.tasks.any((task) => task.isComplete)) {
        branch.filteredTasks =
            branch.tasks.where((task) => !task.isComplete).toList();
        _controller.sink.add(branch);
        return isFiltered = true;
      } else {
        return isFiltered = false;
      }
    } else {
      _controller.sink.add(branch);
      return isFiltered = false;
    }
  }

  bool deleteCompletedTasks(Branch branch) {
    branch.tasks.removeWhere((task) => task.isComplete);
    _controller.sink.add(branch);
    return false;
  }

  void isComplete(Task task) {
    if (task.isComplete) {
      task.isComplete = false;
    } else {
      task.isComplete = true;
    }
  }

  void dispose() {
    _controller.close();
  }
}
