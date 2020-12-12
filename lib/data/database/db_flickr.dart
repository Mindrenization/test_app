// id, parentId, path
import 'package:sqflite/sqflite.dart';
import 'package:test_app/data/database/db.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/image.dart';

const tableImages = 'images';
const tableTask = 'task';

class DbFlickr {
  Future<Database> database = Db.sharedInstance.database;

  Future<void> createImage(Image image) async {
    final db = await database;
    await db.insert(tableImages, image.toMap());
  }

  Future<void> deleteImage(Branch branch) async {
    final db = await database;
    await db.delete(tableImages, where: 'ID="${branch.id}"');
  }

  Future<List<Image>> fetchImageList(taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableImages, where: 'parentID="$taskId"');
    return List.generate(maps.length, (i) {
      return Image(
        maps[i]['ID'],
        maps[i]['parentID'],
        maps[i]['path'],
      );
    });
  }
}
