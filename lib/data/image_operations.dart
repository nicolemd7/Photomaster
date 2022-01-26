import 'database.dart';
import 'package:photomaster/models/image.dart';
import 'package:photomaster/models/tags.dart';

class ImageOperations {
  ImageOperations imageOperations;

  final dbProvider = DatabaseRepository.instance;

  createImage(Image image) async {
    final db = await dbProvider.database;
    var res = db.insert('images', image.toMap());
    return res;
  }

  updateImage(Image image) async {
    final db = await dbProvider.database;
    var res = db.update('images', image.toMap(),
        where: "imageId=?", whereArgs: [image.id]);
    return res;
  }

  deleteImage(Image image) async {
    final db = await dbProvider.database;
    await db.delete('images', where: 'imageId=?', whereArgs: [image.id]);
  }

  Future<List<Image>> getAllImages() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('images');
    List<Image> images = allRows.map((image) => Image.fromMap(image)).toList();
    return images;
  }

  Future<List<Image>> getAllImagesByTags(Tag tag) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.rawQuery('''
    SELECT * FROM images
    WHERE image.FK_image_tags = tagId
    ''');
    List<Image> images = allRows.map((image) => Image.fromMap(image)).toList();
    return images;
  }

//   Future<List<Contact>> searchContacts(String keyword) async {
//     final db = await dbProvider.database;
//     List<Map<String, dynamic>> allRows = await db.query('contact',
//         where: 'contactName LIKE ?', whereArgs: ['%$keyword%']);
//     List<Contact> contacts =
//         allRows.map((contact) => Contact.fromMap(contact)).toList();
//     return contacts;
//   }
}

//WHERE name LIKE 'keyword%'
//--Finds any values that start with "keyword"
//WHERE name LIKE '%keyword'
//--Finds any values that end with "keyword"
//WHERE name LIKE '%keyword%'
//--Finds any values that have "keyword" in any position