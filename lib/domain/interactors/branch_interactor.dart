import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/domain/repository/repository.dart';

class BranchInteractor {
  DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();

  Future<List<Branch>> createBranch(Branch _branch) async {
    await _dbBranchWrapper.createBranch(_branch);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    _branchList.add(_branch);
    return _branchList;
  }

  Future<List<Branch>> deleteBranch(Branch _branch) async {
    await _dbBranchWrapper.deleteBranch(_branch.id);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    _branchList.removeWhere((element) => _branch.id == element.id);
    return _branchList;
  }
}
