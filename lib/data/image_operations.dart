import 'package:photomaster/data/database.dart';
import 'package:photomaster/models/image.dart';
import 'package:photomaster/models/tags.dart';

class ImageOperations {
  ImageOperations imageOperations;

  final dbProvider = DatabaseRepository.instance;

  createImage(Image image) async {
    final db = await dbProvider.database;
    db.insert('image', image.toMap());
    print('image inserted');
  }

  updateImage(Image image) async {
    final db = await dbProvider.database;
    db.update('image', image.toMap(),
        where: "imageId=?", whereArgs: [image.id]);
  }

  deleteImage(Image image) async {
    final db = await dbProvider.database;
    await db.delete('image', where: 'imageId=?', whereArgs: [image.id]);
  }

  Future<List<Image>> getAllImages() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('image');
    List<Image> images = allRows.map((image) => Image.fromMap(image)).toList();
    return images;
  }

  Future<List<Image>> getAllImagesByTags(Tag tag) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.rawQuery('''
    SELECT * FROM contact 
    WHERE image.FK_image_tags = ${tag.id}
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