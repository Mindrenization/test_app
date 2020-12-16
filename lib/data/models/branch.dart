import 'package:test_app/data/models/branch_theme.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/presentation/constants/color_themes.dart';

class Branch {
  final String id;
  final String title;
  int indexColorTheme;
  List<Task> tasks = [];

  BranchTheme get branchTheme => ColorThemes.colorThemes[indexColorTheme];
  int get completedTasks => tasks.where((task) => task.isComplete).length;
  int get uncompletedTasks => tasks.where((task) => !task.isComplete).length;
  int get totalTasks => tasks.length;

  Branch(this.id, this.title, {this.indexColorTheme = 3});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'indexColorTheme': indexColorTheme,
    };
  }
}
