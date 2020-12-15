import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task_step.dart';

class Task {
  final String id;
  final String parentId;
  String title;
  DateTime createDate;
  DateTime deadline;
  DateTime notification;
  String description;
  bool isComplete;
  List<TaskStep> steps = [];
  List<FlickrImage> images = [];

  int get completedSteps => steps.where((step) => step.isComplete).length;
  int get maxSteps => steps.length;

  Task(this.id, this.parentId, this.title, this.createDate, this.deadline, this.notification, {this.description, this.isComplete = false});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'parentID': parentId,
      'title': title,
      'complete': isComplete.toString(),
      'description': description,
      'createDate': createDate.millisecondsSinceEpoch,
      'deadline': deadline == null ? deadline : deadline.millisecondsSinceEpoch,
      'notification': notification == null ? notification : notification.millisecondsSinceEpoch,
    };
  }
}
