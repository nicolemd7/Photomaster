import 'package:photomaster/data/database.dart';
import 'package:photomaster/models/tags.dart';

class TagsOperations {
  TagsOperations tagsOperations;

  final dbProvider = DatabaseRepository.instance;

  createTag(Tag tag) async {
    final db = await dbProvider.database;
    db.insert('tag', tag.toMap());
  }

  Future<List<Tag>> getAllTags() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('tag');
    List<Tag> tags = allRows.map((tag) => Tag.fromMap(tag)).toList();
    return tags;
  }
}
