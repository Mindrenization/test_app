import 'package:bloc/bloc.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/domain/interactors/branch_interactor.dart';
import 'package:test_app/presentation/bloc/branch_event.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/domain/repository/repository.dart';
import 'package:uuid/uuid.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc(BranchState initialState) : super(initialState);
  DbBranchWrapper _dbBranchWrapper = DbBranchWrapper();
  BranchInteractor _branchInteractor = BranchInteractor();

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is FetchBranchList) {
      try {
        List<Branch> _branchList = await _fetchAllDataFromDb();
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(
            branchList: _branchList,
            totalTasks: _totalTasksCount,
            totalCompletedTasks: _totalCompletedTasksCount);
      } catch (_) {
        yield BranchError();
      }
    }
    if (event is UpdateBranchList) {
      try {
        List<Branch> _branchList = _updateBranchList();
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(
            branchList: _branchList,
            totalTasks: _totalTasksCount,
            totalCompletedTasks: _totalCompletedTasksCount);
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
        List<Branch> _branchList =
            await _branchInteractor.deleteBranch(event.branch);
        double _totalTasksCount = _totalTasks(_branchList);
        double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
        yield BranchLoaded(
            branchList: _branchList,
            totalTasks: _totalTasksCount,
            totalCompletedTasks: _totalCompletedTasksCount);
      } catch (_) {
        yield BranchError();
      }
    }
  }

  Future<List<Branch>> _fetchAllDataFromDb() async {
    List<Branch> _branchList = await _dbBranchWrapper.getBranchList();
    _completedTasks(_branchList);
    _uncompletedTasks(_branchList);
    Repository.instance.setBranchList(_branchList);
    return _branchList;
  }

  List<Branch> _updateBranchList() {
    List<Branch> _branchList = Repository.instance.getBranchList();
    _completedTasks(_branchList);
    _uncompletedTasks(_branchList);
    Repository.instance.setBranchList(_branchList);
    return _branchList;
  }

  Future<List<Branch>> _createBranch(String title) async {
    Branch _branch = Branch(Uuid().v1(), title);
    List<Branch> _branchList = await _branchInteractor.createBranch(_branch);
    _completedTasks(_branchList);
    _uncompletedTasks(_branchList);
    return _branchList;
  }

  void _completedTasks(List<Branch> branchList) {
    for (int i = 0; i < branchList.length; i++) {
      branchList[i].completedTasks =
          branchList[i].tasks.where((Task task) => task.isComplete).length;
    }
  }

  void _uncompletedTasks(List<Branch> branchList) {
    for (int i = 0; i < branchList.length; i++) {
      branchList[i].uncompletedTasks =
          branchList[i].tasks.where((Task task) => !task.isComplete).length;
    }
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
      _totalCompletedTasks +=
          branchList[i].tasks.where((Task task) => task.isComplete).length;
    }
    return _totalCompletedTasks;
  }
}
