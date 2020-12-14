import 'package:bloc/bloc.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/branch_repository.dart';
import 'package:test_app/presentation/bloc/branch_event.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc(BranchState initialState) : super(initialState);
  BranchRepository _branchRepository = BranchRepository();

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is FetchBranchList) {
      yield* _mapFetchBranchListEventToState(event);
    }
    if (event is UpdateBranchList) {
      yield* _mapUpdateBranchListEventToState(event);
    }
    if (event is CreateBranch) {
      yield* _mapCreateBranchEventToState(event);
    }
    if (event is DeleteBranch) {
      yield* _mapDeleteBranchEventToState(event);
    }
  }

  Stream<BranchState> _mapFetchBranchListEventToState(FetchBranchList event) async* {
    List<Branch> _branchList = await _updateBranchList();
    double _totalTasksCount = _totalTasks(_branchList);
    double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
    yield BranchLoaded(
      _branchList,
      _totalTasksCount,
      _totalCompletedTasksCount,
    );
  }

  Stream<BranchState> _mapUpdateBranchListEventToState(UpdateBranchList event) async* {
    List<Branch> _branchList = await _updateBranchList();
    double _totalTasksCount = _totalTasks(_branchList);
    double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
    yield BranchLoaded(
      _branchList,
      _totalTasksCount,
      _totalCompletedTasksCount,
    );
  }

  Stream<BranchState> _mapCreateBranchEventToState(CreateBranch event) async* {
    List<Branch> _branchList = await _createBranch(event.title);
    double _totalTasksCount = _totalTasks(_branchList);
    double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
    yield BranchLoaded(
      _branchList,
      _totalTasksCount,
      _totalCompletedTasksCount,
    );
  }

  Stream<BranchState> _mapDeleteBranchEventToState(DeleteBranch event) async* {
    List<Branch> _branchList = await _branchRepository.deleteBranch(event.branch.id);
    double _totalTasksCount = _totalTasks(_branchList);
    double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
    yield BranchLoaded(
      _branchList,
      _totalTasksCount,
      _totalCompletedTasksCount,
    );
  }

  Future<List<Branch>> _updateBranchList() async {
    List<Branch> _branchList = await Repository.instance.getBranchList();

    return _branchList;
  }

  Future<List<Branch>> _createBranch(String title) async {
    Branch _branch = Branch(Uuid().v1(), title);
    List<Branch> _branchList = await _branchRepository.createBranch(_branch);

    return _branchList;
  }

  double _totalTasks(List<Branch> branchList) {
    double _totalTasks = 0.0;
    for (int i = 0; i < branchList.length; i++) {
      _totalTasks += branchList[i].tasks.length;
    }
    return _totalTasks;
  }

  double _totalCompletedTasks(List<Branch> branchList) {
    double _totalCompletedTasks = 0.0;
    for (int i = 0; i < branchList.length; i++) {
      _totalCompletedTasks += branchList[i].tasks.where((task) => task.isComplete).length;
    }
    return _totalCompletedTasks;
  }
}
