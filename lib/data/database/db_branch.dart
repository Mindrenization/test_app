import 'package:sqflite/sqflite.dart';
import 'package:test_app/data/database/db.dart';
import 'package:test_app/data/models/branch.dart';

const tableBranch = 'branch';
const tableTask = 'task';

class DbBranch {
  Future<Database> database = Db.sharedInstance.database;

  Future<void> createBranch(Branch branch) async {
    final db = await database;
    await db.insert(tableBranch, branch.toMap());
  }

  Future<void> deleteBranch(String branchId) async {
    final db = await database;
    await db.delete(tableBranch, where: 'ID="$branchId"');
  }

  Future<void> deleteAllTasks(String branchId) async {
    final db = await database;
    await db.delete(tableTask, where: 'parentID="$branchId"');
  }

  Future<List<Branch>> fetchBranchList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableBranch);
    return List.generate(maps.length, (i) {
      return Branch(
        maps[i]['ID'],
        maps[i]['title'],
      );
    });
  }
}
