import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/repository.dart';

class TaskRepository {
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
    if (_task.notification != null) await NotificationService().cancelNotification(_task);
    await _dbTaskWrapper.deleteTask(_taskId);
    await _dbTaskWrapper.deleteAllSteps(_taskId);
    await _dbTaskWrapper.deleteAllImages(_taskId);
    _taskList.removeWhere((element) => _task.id == element.id);
    return _taskList;
  }

  Future<List<Task>> deleteCompletedTasks(String _branchId) async {
    List<Task> _taskList = Repository.instance.getTaskList(_branchId);
    List<Task> _completedTasks = _taskList.where((task) => task.isComplete).toList();
    for (int i = 0; i < _completedTasks.length; i++) {
      await _dbTaskWrapper.deleteTask(_completedTasks[i].id);
    }
    _taskList.removeWhere((task) => task.isComplete);
    await _dbTaskWrapper.deleteCompletedTasks(_branchId);
    return _taskList;
  }
}
