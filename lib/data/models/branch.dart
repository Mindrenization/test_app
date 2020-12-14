import 'package:test_app/data/models/task.dart';
import 'package:test_app/resources/custom_color_theme.dart';

class Branch {
  final String id;
  final String title;
  List<Task> tasks = [];
  CustomColorTheme customColorTheme = CustomColorTheme();

  int get completedTasks => tasks.where((task) => task.isComplete).length;
  int get uncompletedTasks => tasks.where((task) => !task.isComplete).length;

  Branch(this.id, this.title);

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
    };
  }
}
