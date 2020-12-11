import 'package:flutter/material.dart';
import 'package:test_app/data/models/task.dart';

abstract class TaskState {
  const TaskState();
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final bool isFiltered;
  final List<Task> taskList;
  final Color mainColor;
  final Color backgroundColor;

  const TaskLoaded({
    this.isFiltered = false,
    this.taskList,
    this.mainColor,
    this.backgroundColor,
  });
}

class TaskError extends TaskState {}

class UpdateMainPage extends TaskState {}
