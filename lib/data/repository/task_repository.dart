import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/repository.dart';

class TaskRepository {
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();
  DbFlickr _dbFlickr = DbFlickr();

  Future<void> createTask(Task task, String branchId) async {
    await _dbTaskWrapper.createTask(task);
    Repository.instance.createTask(task, branchId);
  }

  Future<void> deleteTask(String branchId, String taskId) async {
    Task _task = Repository.instance.getTask(branchId, taskId);
    if (_task.notification != null) {
      await NotificationService().cancelNotification(_task);
    }
    await _dbTaskWrapper.deleteTask(taskId);
    await _dbTaskWrapper.deleteAllSteps(taskId);
    await _dbTaskWrapper.deleteAllImages(taskId);
    Repository.instance.deleteTask(branchId, taskId);
  }

  Future<void> deleteCompletedTasks(String branchId) async {
    List<Task> _taskList = Repository.instance.getTaskList(branchId);
    List<Task> _completedTasks = _taskList.where((task) => task.isComplete).toList();
    for (int i = 0; i < _completedTasks.length; i++) {
      await deleteTask(branchId, _completedTasks[i].id);
    }
  }

  Future<void> saveImage(String branchId, String taskId, FlickrImage image) async {
    await _dbFlickr.saveImage(image);
    Repository.instance.saveImage(branchId, taskId, image);
  }

  Future<void> deleteImage(String branchId, String taskId, String imageId) async {
    await _dbTaskWrapper.deleteImage(imageId);
    Repository.instance.deleteImage(branchId, taskId, imageId);
  }
}
