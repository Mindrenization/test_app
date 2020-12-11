import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/database/db_task.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';

class DbTaskWrapper {
  DbTask _dbTask = DbTask();
  DbStepWrapper _dbStepWrapper = DbStepWrapper();

  Future<List<Task>> getTaskList(Branch branch) async {
    var taskList = await _dbTask.fetchTaskList(branch);
    for (int i = 0; i < taskList.length; i++) {
      taskList[i].steps = await _dbStepWrapper.getStepList(taskList[i].id);
      taskList[i].maxSteps = taskList[i].steps.length;
      taskList[i].completedSteps = taskList[i]
          .steps
          .where((TaskStep element) => element.isComplete)
          .length;
    }
    return taskList;
  }

  Future<void> createTask(Task task) async {
    await _dbTask.createTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _dbTask.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    await _dbTask.deleteTask(task);
    await _dbTask.deleteAllSteps(task);
  }

  Future<void> deleteCompletedTasks(String branchId) async {
    await _dbTask.deleteCompletedTasks(branchId);
  }
}
