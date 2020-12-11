import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:test_app/data/repository/task_repository.dart';

class BranchRepository {
  DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();
  TaskRepository _taskRepository = TaskRepository();

  Future<List<Branch>> createBranch(Branch _branch) async {
    await _dbBranchWrapper.createBranch(_branch);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    _branchList.add(_branch);
    return _branchList;
  }

  Future<List<Branch>> deleteBranch(String _branchId) async {
    await _dbBranchWrapper.deleteBranch(_branchId);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    List<Task> _taskList = _branchList.firstWhere((element) => _branchId == element.id).tasks;
    for (int i = 0; i < _taskList.length; i++) {
      _taskRepository.deleteTask(_branchId, _taskList[i].id);
    }
    _branchList.removeWhere((element) => _branchId == element.id);
    return _branchList;
  }
}
