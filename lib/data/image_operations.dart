import 'package:photomaster/data/tags_operations.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'package:photomaster/models/image.dart';
import 'package:photomaster/models/tags.dart';

class ImageOperations {
  TagsOperations tagsOperations = TagsOperations();

  final dbProvider = DatabaseRepository.instance;

  Future<bool> imageExists(ImageDetails image) async {
    final db = await dbProvider.database;
    print(image.id);
    List<Map<String, dynamic>> tag = await db.rawQuery("SELECT * FROM images");
    print(tag);
    var res = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM images WHERE imageId=?', [image.id]));
    print(res);
    if(res > 0) return true;
    else return false;
  }

  createImage(ImageDetails image) async {
    var db = await dbProvider.database;
    var res = db.insert('images', image.toMap());
    return res;
  }

  getAllTagsFor(ImageDetails image) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> tag = await db.rawQuery("SELECT * FROM transactions WHERE FimageId=?", [image.id]);
    print("tags for img: $tag");

    // iterate through all the tags in that image and get the foreign key
    // create list of type Tag
    image.resetTag();

    await Future.forEach(tag, (obj) async {
      print("obj $obj");
      Tag t = await tagsOperations.fetchTag(obj['FtagId']);
      image.addTag(t);
    });
    print("tags for img (w): ${image.tag}");
  }

  addTag(ImageDetails image, Tag tag) async {
    final db = await dbProvider.database;
    // Check if already exists
    if(!image.inDatabase) {
      await createImage(image);
      image.inDatabase = true;
    }
    Map<String, dynamic> row = {
      "FtagId": tag.id,
      "FimageId": image.id,
    };
    await db.insert('transactions', row);
//    getAllTagsFor(image);
//    await db.execute("CREATE TABLE IF NOT EXISTS transactions("
//        "FtagId INTEGER NOT NULL,"
//        "FimageId INTEGER NOT NULL,"
//        "FOREIGN KEY (FtagId) REFERENCES tager(tagId),"
//        "FOREIGN KEY (FimageId) REFERENCES images(imageId)"
//        ");");
  }

  updateImage(ImageDetails image) async {
    final db = await dbProvider.database;
    var res = db.update('images', image.toMap(),
        where: "imageId=?", whereArgs: [image.id]);
    return res;
  }

  deleteImage(ImageDetails image) async {
    final db = await dbProvider.database;
    await db.delete('images', where: 'imageId=?', whereArgs: [image.id]);
  }

  Future<List<ImageDetails>> getAllImages() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('images');
    List<ImageDetails> images = allRows.map((image) => ImageDetails.fromMap(image)).toList();
    return images;
  }

  Future<void> removeTag(ImageDetails image, Tag tag) async {
    final db = await dbProvider.database;

    db.delete('transactions', where: "FimageId=? and FtagId=?", whereArgs: [image.id, tag.id],);
  }
  //Weird
//  Future<List<ImageDetails>> getAllTaggedImages(Tag tag) async {
//    final db = await dbProvider.database;
//    List<Map<String, dynamic>> allRows = await db.rawQuery('''
//    SELECT * FROM images
//    WHERE images.FK_image_tags = FK_tagId
//    ''');
//
//    List<ImageDetails> images = allRows.map((image) => ImageDetails.fromMap(image)).toList();
//    return images;
//  }
//
//  Future<List<ImageDetails>> getAllImagesByTags(Tag tag) async {
//    final db = await dbProvider.database;
//    List<Map<String, dynamic>> allRows = await db.rawQuery('''
//    SELECT * FROM images
//    WHERE images.FK_image_tags = tagId
//    ''');
//    List<ImageDetails> images = allRows.map((image) => ImageDetails.fromMap(image)).toList();
//    return images;
//  }

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
