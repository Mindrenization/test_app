import 'package:sqflite/sqflite.dart';
import 'package:test_app/data/database/db.dart';
import 'package:test_app/data/models/task.dart';

const tableTask = 'task';
const tableStep = 'step';
const tableImages = 'images';

class DbTask {
  Future<Database> database = Db.sharedInstance.database;

  Future<void> createTask(Task task) async {
    final db = await database;
    await db.insert(tableTask, task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(tableTask, task.toMap(), where: 'ID="${task.id}"');
  }

  Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete(tableTask, where: 'ID="$taskId"');
  }

  Future<void> deleteCompletedTasks(String branchId) async {
    final db = await database;
    await db.delete(tableTask, where: 'parentID="$branchId" AND complete="true"');
  }

  Future<void> deleteAllSteps(String taskId) async {
    final db = await database;
    await db.delete(tableStep, where: 'parentID="$taskId"');
  }

  Future<void> deleteImage(String imageId) async {
    final db = await database;
    await db.delete(tableImages, where: 'ID="$imageId"');
  }

  Future<void> deleteAllImages(String taskId) async {
    final db = await database;
    await db.delete(tableImages, where: 'parentID="$taskId"');
  }

  Future<List<Task>> fetchTaskList(String branchId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableTask, where: 'parentID="$branchId"');
    return List.generate(maps.length, (i) {
      return Task(
        maps[i]['ID'],
        maps[i]['parentID'],
        maps[i]['title'],
        isComplete: maps[i]['complete'] == 'true' ? true : false,
        description: maps[i]['description'],
        createDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['createDate']),
        deadline: maps[i]['deadline'] == null ? null : DateTime.fromMillisecondsSinceEpoch(maps[i]['deadline']),
      );
    });
  }
}
