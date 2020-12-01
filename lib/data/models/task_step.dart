class TaskStep {
  final String id;
  final String parentId;
  final String title;
  bool isComplete;

  TaskStep(this.title, {this.id, this.parentId, this.isComplete = false});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'parentID': parentId,
      'title': title,
      'complete': isComplete.toString(),
    };
  }
}
