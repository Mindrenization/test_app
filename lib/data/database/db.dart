import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const databaseName = 'todo.db';
const sqlCreateStatementBranch = '''
CREATE TABLE "branch"(
  "ID" TEXT NOT NULL PRIMARY KEY,
  "title" TEXT NOT NULL
);''';
const sqlCreateStatementTask = '''
CREATE TABLE "task"(
  "ID" TEXT NOT NULL PRIMARY KEY,
  "parentID" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "complete" TEXT NOT NULL,
  "description" TEXT,
  "createDate" INTEGER,
  "deadline" INTEGER
);''';
const sqlCreateStatementStep = '''
CREATE TABLE "step"(
  "ID" TEXT NOT NULL PRIMARY KEY,
  "parentID" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "complete" TEXT NOT NULL
);''';
const sqlCreateStatementImages = '''
CREATE TABLE "images"(
  "ID" TEXT NOT NULL PRIMARY KEY,
  "parentID" TEXT NOT NULL,
  "path" TEXT NOT NULL
);''';

class Db {
  Db._();
  static final Db sharedInstance = Db._();

  Database _database;
  Future<Database> get database async {
    return _database ?? await initDB();
  }

  Future<Database> initDB() async {
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, databaseName);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(sqlCreateStatementBranch);
      await db.execute(sqlCreateStatementTask);
      await db.execute(sqlCreateStatementStep);
      await db.execute(sqlCreateStatementImages);
    });
  }
}
