import 'package:test_app/data/database/db_branch.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/branch.dart';

class DbBranchWrapper {
  DbBranch _dbBranch = DbBranch();
  DbTaskWrapper _dbTaskWrapper = DbTaskWrapper();

  Future<List<Branch>> getBranchList() async {
    var branchList = await _dbBranch.fetchBranchList();
    for (int i = 0; i < branchList.length; i++) {
      branchList[i].tasks = await _dbTaskWrapper.getTaskList(branchList[i].id);
    }
    return branchList;
  }

  Future<void> createBranch(Branch branch) async {
    await _dbBranch.createBranch(branch);
  }

  Future<void> deleteBranch(String branchId) async {
    await _dbBranch.deleteBranch(branchId);
    await _dbBranch.deleteAllTasks(branchId);
  }
}
