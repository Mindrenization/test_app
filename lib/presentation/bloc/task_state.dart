import 'package:flutter/material.dart';
import 'package:test_app/data/models/task.dart';

abstract class TaskState {
  const TaskState();
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> taskList;
  final Color mainColor;
  final Color backgroundColor;
  final bool isFiltered;

  const TaskLoaded(
    this.taskList,
    this.mainColor,
    this.backgroundColor, {
    this.isFiltered = false,
  });
}

class TaskError extends TaskState {}

class UpdateMainPage extends TaskState {}
