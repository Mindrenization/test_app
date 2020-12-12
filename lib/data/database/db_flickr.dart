import 'package:sqflite/sqflite.dart';
import 'package:test_app/data/database/db.dart';
import 'package:test_app/data/models/flickr_image.dart';

const tableImages = 'images';
const tableTask = 'task';

class DbFlickr {
  Future<Database> database = Db.sharedInstance.database;

  Future<void> createImage(FlickrImage image) async {
    final db = await database;
    await db.insert(tableImages, image.toMap());
  }

  Future<List<FlickrImage>> fetchImageList(String taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableImages, where: 'parentID="$taskId"');
    return List.generate(maps.length, (i) {
      return FlickrImage(
        maps[i]['ID'],
        maps[i]['parentID'],
        maps[i]['path'],
      );
    });
  }
}
