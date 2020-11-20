import 'package:bloc/bloc.dart';
import 'package:test_app/blocs/branch_event.dart';
import 'package:test_app/blocs/branch_state.dart';
import 'package:test_app/models/branch.dart';
import 'package:test_app/models/task.dart';
import 'package:test_app/repository/branch_list.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc(BranchState initialState) : super(initialState);

  @override
  Stream<BranchState> mapEventToState(BranchEvent event) async* {
    if (event is FetchBranchList) {
      yield BranchLoading();
      try {
        var branch = await BranchList.getBranch();
        yield BranchLoaded(branchList: branch);
      } catch (_) {
        yield BranchError();
      }
    }
    if (event is CreateBranch) {
      _createBranch(event.title);
      try {
        var branch = await BranchList.getBranch();
        yield BranchLoaded(branchList: branch);
      } catch (_) {
        yield BranchError();
      }
    }
    if (event is DeleteBranch) {
      _deleteBranch(event.index);
      try {
        var branch = await BranchList.getBranch();
        yield BranchLoaded(branchList: branch);
      } catch (_) {
        yield BranchError();
      }
    }
  }
}

void _createBranch(String title) {
  var lastTaskId =
      BranchList.branchList.isEmpty ? 0 : BranchList.branchList.last.id;
  BranchList.branchList.add(
    Branch(++lastTaskId, title),
  );
}

void _deleteBranch(int index) {
  BranchList.branchList
      .removeWhere((branch) => branch.id == BranchList.branchList[index].id);
}

int completedTasks(int index) {
  return BranchList.branchList[index].tasks
      .where((Task task) => task.isComplete)
      .length;
}

int uncompletedTasks(int index) {
  return BranchList.branchList[index].tasks
      .where((Task task) => !task.isComplete)
      .length;
}

double totalTasks() {
  double _totalTasks = 0;
  if (BranchList.branchList != null)
    for (var i = 0; i < BranchList.branchList.length; i++) {
      _totalTasks += BranchList.branchList[i].tasks.length;
    }
  return _totalTasks;
}

double totalCompletedTasks() {
  double _totalCompletedTasks = 0;
  if (BranchList.branchList != null)
    for (var i = 0; i < BranchList.branchList.length; i++) {
      _totalCompletedTasks += BranchList.branchList[i].tasks
          .where((Task task) => task.isComplete)
          .length;
    }
  return _totalCompletedTasks;
}
