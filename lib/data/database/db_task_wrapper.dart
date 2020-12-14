import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/database/db_task.dart';
import 'package:test_app/data/models/task.dart';

class DbTaskWrapper {
  DbTask _dbTask = DbTask();
  DbStepWrapper _dbStepWrapper = DbStepWrapper();
  DbFlickr _dbFlickr = DbFlickr();

  Future<List<Task>> getTaskList(String branchId) async {
    var taskList = await _dbTask.fetchTaskList(branchId);
    for (int i = 0; i < taskList.length; i++) {
      taskList[i].steps = await _dbStepWrapper.getStepList(taskList[i].id);
      taskList[i].images = await _dbFlickr.fetchImageList(taskList[i].id);
    }
    return taskList;
  }

  Future<void> createTask(Task task) async {
    await _dbTask.createTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _dbTask.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    await _dbTask.deleteTask(taskId);
    await _dbTask.deleteAllSteps(taskId);
  }

  Future<void> deleteCompletedTasks(String branchId) async {
    await _dbTask.deleteCompletedTasks(branchId);
  }

  Future<void> deleteAllSteps(String taskId) async {
    await _dbTask.deleteAllSteps(taskId);
  }

  Future<void> deleteImage(String imageId) async {
    await _dbTask.deleteImage(imageId);
  }

  Future<void> deleteAllImages(String taskId) async {
    await _dbTask.deleteAllImages(taskId);
  }
}
