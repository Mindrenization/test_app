import 'package:test_app/data/models/branch.dart';

abstract class BranchEvent {
  const BranchEvent();
}

class FetchBranchList extends BranchEvent {}

class CreateBranch extends BranchEvent {
  final String title;
  final int index;
  const CreateBranch(this.title, this.index);
}

class DeleteBranch extends BranchEvent {
  final Branch branch;
  const DeleteBranch(this.branch);
}
