import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:test_app/data/repository/task_repository.dart';

class BranchRepository {
  final Repository repository;
  final DbBranchWrapper dbBranchWrapper;
  final TaskRepository taskRepository;
  BranchRepository(this.repository, this.dbBranchWrapper, this.taskRepository);

  Future<void> createBranch(Branch branch) async {
    await dbBranchWrapper.createBranch(branch);
    repository.createBranch(branch);
  }

  Future<void> deleteBranch(String branchId) async {
    await dbBranchWrapper.deleteBranch(branchId);
    List<Branch> _branchList = await repository.getBranchList();
    List<Task> _taskList = _branchList.firstWhere((element) => branchId == element.id, orElse: () => null).tasks;
    for (int i = 0; i < _taskList.length; i++) {
      await taskRepository.deleteTask(branchId, _taskList[i].id);
    }
    repository.deleteBranch(branchId);
  }
}
