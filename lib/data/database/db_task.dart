import 'package:sqflite/sqflite.dart';
import 'package:test_app/data/database/db.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/task.dart';

const tableTask = 'task';
const tableStep = 'step';

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

  Future<void> deleteTask(Task task) async {
    final db = await database;
    await db.delete(tableTask, where: 'ID="${task.id}"');
  }

  Future<void> deleteCompletedTasks(String branchId) async {
    final db = await database;
    await db.delete(tableTask,
        where: 'parentID="$branchId" AND complete="true"');
  }

  Future<void> deleteAllSteps(Task task) async {
    final db = await database;
    await db.delete(tableStep, where: 'parentID="${task.id}"');
  }

  Future<List<Task>> fetchTaskList(Branch branch) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableTask, where: 'parentID="${branch.id}"');
    return List.generate(maps.length, (i) {
      return Task(
        maps[i]['title'],
        id: maps[i]['ID'],
        parentId: maps[i]['parentID'],
        isComplete: maps[i]['complete'] == 'true' ? true : false,
        description: maps[i]['description'],
        createDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['createDate']),
        deadline: maps[i]['deadline'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(maps[i]['deadline']),
      );
    });
  }
}
