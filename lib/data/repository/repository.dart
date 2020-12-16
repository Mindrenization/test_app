import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';

class Repository {
  static final Repository _instance = Repository._();
  Repository._();
  List<Branch> _branchList;

  static Repository getInstance() {
    return _instance;
  }

  Future<List<Branch>> getBranchList() async {
    DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();
    return Repository._instance._branchList = _branchList ?? await _dbBranchWrapper.fetchBranchList();
  }

  Branch getBranch(String branchId) {
    return _branchList.firstWhere((branch) => branchId == branch.id, orElse: () => null);
  }

  void createBranch(Branch branch) {
    _branchList.add(branch);
  }

  void deleteBranch(String branchId) {
    _branchList.removeWhere((branch) => branchId == branch.id);
  }

  List<Task> getTaskList(String branchId) {
    return getBranch(branchId).tasks;
  }

  Task getTask(String branchId, String taskId) {
    return getBranch(branchId).tasks.firstWhere((task) => taskId == task.id, orElse: () => null);
  }

  void createTask(Task task, String branchId) {
    Branch _branch = getBranch(branchId);
    _branch.tasks.add(task);
  }

  void deleteTask(String branchId, String taskId) {
    Branch _branch = getBranch(branchId);
    _branch.tasks.removeWhere((task) => taskId == task.id);
  }

  FlickrImage getImage(branchId, taskId, imageId) {
    return getTask(branchId, taskId).images.firstWhere((element) => imageId == element.id, orElse: () => null);
  }

  List<TaskStep> getStepList(String branchId, String taskId) {
    return getTask(branchId, taskId).steps;
  }

  TaskStep getStep(String branchId, String taskId, String stepId) {
    return getStepList(branchId, taskId).firstWhere((element) => stepId == element.id, orElse: () => null);
  }

  void createStep(String branchId, String taskId, TaskStep step) {
    Task _task = getTask(branchId, taskId);
    _task.steps.add(step);
  }

  void deleteStep(String branchId, String taskId, String stepId) {
    Task _task = getTask(branchId, taskId);
    _task.steps.removeWhere((step) => stepId == step.id);
  }

  void saveImage(String branchId, String taskId, FlickrImage image) {
    Task _task = getTask(branchId, taskId);
    _task.images.add(image);
  }

  void deleteImage(String branchId, String taskId, String imageId) {
    Task _task = getTask(branchId, taskId);
    _task.images.removeWhere((image) => imageId == image.id);
  }
}
