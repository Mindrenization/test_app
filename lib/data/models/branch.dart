import 'package:test_app/data/models/task.dart';
import 'package:test_app/resources/custom_color_theme.dart';

class Branch {
  final String id;
  final String title;
  int completedTasks;
  int uncompletedTasks;
  List<Task> tasks = [];
  CustomColorTheme customColorTheme = CustomColorTheme();

  Branch(this.id, this.title);

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
    };
  }
}
