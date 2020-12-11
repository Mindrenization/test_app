import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/domain/repository/repository.dart';

class TaskInteractor {
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();

  Future<List<Task>> createTask(Task _task, String _branchId) async {
    List<Task> _taskList = Repository.instance.getTaskList(_branchId);
    await _dbTaskWrapper.createTask(_task);
    _taskList.add(_task);
    return _taskList;
  }

  Future<List<Task>> deleteTask(String _branchId, String _taskId) async {
    List<Task> _taskList = Repository.instance.getTaskList(_branchId);
    Task _task = Repository.instance.getTask(_branchId, _taskId);
    await _dbTaskWrapper.deleteTask(_task);
    _taskList.removeWhere((element) => _task.id == element.id);
    return _taskList;
  }
}
