import 'package:test_app/models/task.dart';
import 'package:test_app/resources/custom_color_theme.dart';

class Branch {
  final int id;
  final String title;
  List<Task> tasks = [];
  CustomColorTheme customColorTheme = CustomColorTheme();

  Branch(this.id, this.title);
}
