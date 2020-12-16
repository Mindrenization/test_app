import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/repository.dart';

class TaskRepository {
  final Repository repository;
  final DbTaskWrapper dbTaskWrapper;
  final DbFlickr dbFlickr;
  final NotificationService notificationService;
  TaskRepository(this.repository, this.dbTaskWrapper, this.dbFlickr, this.notificationService);

  Future<void> createTask(Task task, String branchId) async {
    await dbTaskWrapper.createTask(task);
    repository.createTask(task, branchId);
  }

  Future<void> deleteTask(String branchId, String taskId) async {
    Task _task = repository.getTask(branchId, taskId);
    if (_task.notification != null) {
      await notificationService.cancelNotification(_task);
    }
    await dbTaskWrapper.deleteTask(taskId);
    await dbTaskWrapper.deleteAllSteps(taskId);
    await dbTaskWrapper.deleteAllImages(taskId);
    repository.deleteTask(branchId, taskId);
  }

  Future<void> deleteCompletedTasks(String branchId) async {
    List<Task> _taskList = repository.getTaskList(branchId);
    List<Task> _completedTasks = _taskList.where((task) => task.isComplete).toList();
    for (int i = 0; i < _completedTasks.length; i++) {
      await deleteTask(branchId, _completedTasks[i].id);
    }
  }

  Future<void> saveImage(String branchId, String taskId, FlickrImage image) async {
    await dbFlickr.saveImage(image);
    repository.saveImage(branchId, taskId, image);
  }

  Future<void> deleteImage(String branchId, String taskId, String imageId) async {
    await dbTaskWrapper.deleteImage(imageId);
    repository.deleteImage(branchId, taskId, imageId);
  }
}
