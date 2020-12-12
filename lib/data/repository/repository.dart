import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';

class Repository {
  static final instance = Repository();
  List<Branch> _branchList;

  Future<List<Branch>> getBranchList() async {
    DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();
    return Repository.instance._branchList =
        _branchList ?? await _dbBranchWrapper.getBranchList();
  }

  Branch getBranch(String id) {
    return _branchList.firstWhere((element) => id == element.id);
  }

  List<Task> getTaskList(String id) {
    return getBranch(id).tasks;
  }

  Task getTask(String branchId, String taskId) {
    return getBranch(branchId)
        .tasks
        .firstWhere((element) => taskId == element.id);
  }

  Image getImage(branchId, taskId, imageId) {
    return getTask(branchId, taskId)
        .images
        .firstWhere((element) => imageId == element.id);
  }

  List<TaskStep> getStepList(String branchId, String taskId) {
    return getTask(branchId, taskId).steps;
  }

  TaskStep getStep(String branchId, String taskId, String stepId) {
    return getStepList(branchId, taskId)
        .firstWhere((element) => stepId == element.id);
  }
}
