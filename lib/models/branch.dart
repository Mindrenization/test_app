import 'package:test_app/models/task.dart';

class Branch {
  final int id;
  final String title;
  List<Task> tasks = [];

  Branch(this.id, this.title);
}
