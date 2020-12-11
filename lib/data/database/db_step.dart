import 'package:sqflite/sqflite.dart';
import 'package:test_app/data/database/db.dart';
import 'package:test_app/data/models/task_step.dart';

const tableStep = 'step';

class DbStep {
  Future<Database> database = Db.sharedInstance.database;

  Future<void> createStep(TaskStep step) async {
    final db = await database;
    await db.insert(tableStep, step.toMap());
  }

  Future<void> updateStep(TaskStep step) async {
    final db = await database;
    await db.update(tableStep, step.toMap(), where: 'ID="${step.id}"');
  }

  Future<void> deleteStep(String stepId) async {
    final db = await database;
    await db.delete(tableStep, where: 'ID="$stepId"');
  }

  Future<List<TaskStep>> fetchStepList(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableStep, where: 'parentID="$id"');
    return List.generate(maps.length, (i) {
      return TaskStep(maps[i]['title'],
          id: maps[i]['ID'], parentId: maps[i]['parentID'], isComplete: maps[i]['complete'] == 'true' ? true : false);
    });
  }
}
