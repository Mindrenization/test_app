import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:test_app/data/repository/task_repository.dart';

class BranchRepository {
  DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();
  TaskRepository _taskRepository = TaskRepository();

  Future<void> createBranch(Branch branch) async {
    await _dbBranchWrapper.createBranch(branch);
    Repository.instance.createBranch(branch);
  }

  Future<void> deleteBranch(String branchId) async {
    await _dbBranchWrapper.deleteBranch(branchId);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    List<Task> _taskList = _branchList.firstWhere((element) => branchId == element.id).tasks;
    for (int i = 0; i < _taskList.length; i++) {
      await _taskRepository.deleteTask(branchId, _taskList[i].id);
    }
    Repository.instance.deleteBranch(branchId);
  }
}
