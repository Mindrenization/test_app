import 'package:bloc/bloc.dart';
import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/task_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/branch_repository.dart';
import 'package:test_app/presentation/bloc/branch_event.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/data/repository/repository.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc() : super(BranchLoading());
  BranchRepository _branchRepository = BranchRepository(
      Repository.getInstance(),
      DbBranchWrapper(),
      TaskRepository(
        Repository.getInstance(),
        DbTaskWrapper(),
        DbFlickr(),
        NotificationService(),
      ));

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is FetchBranchList) {
      yield* _mapFetchBranchListEventToState(event);
    } else if (event is CreateBranch) {
      yield* _mapCreateBranchEventToState(event);
    } else if (event is DeleteBranch) {
      yield* _mapDeleteBranchEventToState(event);
    }
  }

  Stream<BranchState> _mapFetchBranchListEventToState(FetchBranchList event) async* {
    List<Branch> _branchList = await _fetchBranchList();
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
    await _branchRepository.deleteBranch(event.branch.id);
    List<Branch> _branchList = await Repository.getInstance().getBranchList();
    double _totalTasksCount = _totalTasks(_branchList);
    double _totalCompletedTasksCount = _totalCompletedTasks(_branchList);
    yield BranchLoaded(
      _branchList,
      _totalTasksCount,
      _totalCompletedTasksCount,
    );
  }

  Future<List<Branch>> _fetchBranchList() async {
    List<Branch> _branchList = await Repository.getInstance().getBranchList();
    return _branchList;
  }

  Future<List<Branch>> _createBranch(String title) async {
    Branch _branch = Branch(Uuid().v1(), title);
    await _branchRepository.createBranch(_branch);
    List<Branch> _branchList = await Repository.getInstance().getBranchList();
    return _branchList;
  }

  double _totalTasks(branchList) {
    double totalTasksCount = 0.0;
    for (int i = 0; i < branchList.length; i++) {
      totalTasksCount += branchList[i].tasks.length;
    }
    return totalTasksCount;
  }

  double _totalCompletedTasks(branchList) {
    double _totalCompletedTasks = 0.0;
    for (int i = 0; i < branchList.length; i++) {
      _totalCompletedTasks += branchList[i].tasks.where((Task task) => task.isComplete).length;
    }
    return _totalCompletedTasks;
  }
}
