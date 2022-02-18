import 'package:photomaster/data/database.dart';
import 'package:photomaster/models/tags.dart';
import 'database.dart';
import 'package:photomaster/models/image.dart';

class  TagsOperations {
  TagsOperations tagsOperations;

  final dbProvider = DatabaseRepository.instance;

  createTag(Tag tag) async {
    final db = await dbProvider.database;
    db.insert('tager', tag.toMap());
  }

  assignTag(Image image) async {
    final db = await dbProvider.database;
    var res = db.update('images', image.toMap(),
        where: "FK_image_tags=?", whereArgs: [image.tag]);
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

   Future<List<Tag>> getAllTags() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('tager');
    List<Tag> tags = allRows.map((tag) => Tag.fromMap(tag)).toList();
    return tags;
  }
}
