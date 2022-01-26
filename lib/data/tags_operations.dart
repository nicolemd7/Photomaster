import 'package:photomaster/data/database.dart';
import 'package:photomaster/models/tags.dart';

class TagsOperations {
  TagsOperations tagsOperations;

  final dbProvider = DatabaseRepository.instance;

  createTag(Tag tag) async {
    final db = await dbProvider.database;
    db.insert('tager', tag.toMap());
  }

  Future<List<Tag>> getAllTags() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('tager');
    List<Tag> tags = allRows.map((tag) => Tag.fromMap(tag)).toList();
    return tags;
  }
}
