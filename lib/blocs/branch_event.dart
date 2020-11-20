abstract class BranchEvent {
  const BranchEvent();
}

class FetchBranchList extends BranchEvent {
  const FetchBranchList();
}

class CreateBranch extends BranchEvent {
  final String title;
  const CreateBranch({this.title});
}

class DeleteBranch extends BranchEvent {
  final int index;
  const DeleteBranch({this.index});
}
