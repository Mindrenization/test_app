import 'package:bloc/bloc.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/branch_repository.dart';
import 'package:test_app/presentation/bloc/branch_event.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc(BranchState initialState) : super(initialState);
  BranchInteractor _branchInteractor = BranchInteractor();

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is FetchBranchList) {
      try {
        List<Branch> _branchList = await _updateBranchList();
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(
          branchList: _branchList,
          totalTasks: _totalTasksCount,
          totalCompletedTasks: _totalCompletedTasksCount,
        );
      } catch (_) {
        yield BranchError();
      }
    }
    if (event is UpdateBranchList) {
      try {
        List<Branch> _branchList = await _updateBranchList();
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(branchList: _branchList, totalTasks: _totalTasksCount, totalCompletedTasks: _totalCompletedTasksCount);
      } catch (_) {
        yield BranchError();
      }
    }
    if (event is CreateBranch) {
      try {
        List<Branch> _branchList = await _createBranch(event.title);
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(
          branchList: _branchList,
          totalTasks: _totalTasksCount,
          totalCompletedTasks: _totalCompletedTasksCount,
        );
      } catch (_) {
        yield BranchError();
      }
    }
    if (event is DeleteBranch) {
      try {
        List<Branch> _branchList = await _branchInteractor.deleteBranch(event.branch.id);
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(branchList: _branchList, totalTasks: _totalTasksCount, totalCompletedTasks: _totalCompletedTasksCount);
      } catch (_) {
        yield BranchError();
      }
    }
  }

  Future<List<Branch>> _updateBranchList() async {
    List<Branch> _branchList = await Repository.instance.getBranchList();

    return _branchList;
  }

  Future<List<Branch>> _createBranch(String title) async {
    Branch _branch = Branch(Uuid().v1(), title);
    List<Branch> _branchList = await _branchInteractor.createBranch(_branch);

    return _branchList;
  }

  double _totalTasks(branchList) {
    double _totalTasks = 0.0;
    for (var i = 0; i < branchList.length; i++) {
      _totalTasks += branchList[i].tasks.length;
    }
    return _totalTasks;
  }

  double _totalCompletedTasks(branchList) {
    double _totalCompletedTasks = 0.0;
    for (var i = 0; i < branchList.length; i++) {
      _totalCompletedTasks += branchList[i].tasks.where((Task task) => task.isComplete).length;
    }
    return _totalCompletedTasks;
  }
}
