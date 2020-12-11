import 'package:flutter/material.dart';
import 'package:test_app/data/models/task.dart';

class Branch {
  final String id;
  final String title;
  int completedTasks;
  int uncompletedTasks;
  List<Task> tasks = [];
  Color mainColor = const Color(0xFF6202EE);
  Color backgroundColor = const Color.fromRGBO(181, 201, 253, 1);

  Branch(this.id, this.title);

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
    };
  }
}
