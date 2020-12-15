import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/branch_repository.dart';
import 'package:test_app/presentation/bloc/branch_event.dart';
import 'package:test_app/presentation/bloc/branch_state.dart';
import 'package:test_app/data/repository/repository.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc() : super(BranchLoading());
  BranchRepository _branchRepository = BranchRepository();

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
    yield BranchLoaded(
      _branchList,
    );
  }

  Stream<BranchState> _mapCreateBranchEventToState(CreateBranch event) async* {
    List<Branch> _branchList = await _createBranch(event.title);
    yield BranchLoaded(
      _branchList,
    );
  }

  Stream<BranchState> _mapDeleteBranchEventToState(DeleteBranch event) async* {
    await _branchRepository.deleteBranch(event.branch.id);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    yield BranchLoaded(
      _branchList,
    );
  }

  Future<List<Branch>> _fetchBranchList() async {
    List<Branch> _branchList = await Repository.instance.getBranchList();
    return _branchList;
  }

  Future<List<Branch>> _createBranch(String title) async {
    Branch _branch = Branch(Uuid().v1(), title);
    await _branchRepository.createBranch(_branch);
    List<Branch> _branchList = await Repository.instance.getBranchList();
    return _branchList;
  }
}
