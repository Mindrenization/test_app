import 'package:test_app/data/models/branch.dart';

abstract class BranchEvent {
  const BranchEvent();
}

class FetchBranchList extends BranchEvent {
  const FetchBranchList();
}

class CreateBranch extends BranchEvent {
  final String title;
  const CreateBranch(this.title);
}

class DeleteBranch extends BranchEvent {
  final Branch branch;
  const DeleteBranch(this.branch);
}

class UpdateBranchList extends BranchEvent {
  const UpdateBranchList();
}
