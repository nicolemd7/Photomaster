import 'dart:io';
import 'package:photomaster/models/image.dart';
import 'package:photomaster/models/tags.dart';
import 'package:sqflite/sqflite.dart' show Database, openDatabase;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseRepository {
  DatabaseRepository._();

  static final DatabaseRepository instance = DatabaseRepository._();

  static const _databaseName = 'img_deets.db';

  final _databaseVersion = 1;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print("YOU HAVE REACHED DB CREATION");
    print("db location " + documentsDirectory.path);
    String path = join(documentsDirectory.path, _databaseName);
    _database = await openDatabase(path, version: _databaseVersion, onOpen: (db) async {
      await db.execute("CREATE TABLE IF NOT EXISTS images("
          "imageId INTEGER PRIMARY KEY,"
          "imagePath STRING NOT NULL,"
          "FK_image_tags INTEGER NOT NULL,"
          "FOREIGN KEY (FK_image_tags) REFERENCES tager (tagId) "
          ");");
      print("TB CREATED1");
      await db.execute("CREATE TABLE IF NOT EXISTS tager("
          " tagId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "tagName STRING NOT NULL,"
          "unique(tagName)"
          "  );");
      print("TB CREATED2");
      await db.execute("CREATE TABLE IF NOT EXISTS transactions("
          "FtagId INTEGER NOT NULL,"
          "FimageId INTEGER NOT NULL,"
          "FOREIGN KEY (FtagId) REFERENCES tager (tagId),"
          "FOREIGN KEY (FimageId) REFERENCES images (imageId)"
          ");");
      print("TB CREATED3");
      await db.execute("CREATE TABLE IF NOT EXISTS geotag("
          "id INTEGER NOT NULL,"
          "lat FLOAT NOT NULL,"
          "long FLOAT NOT NULL"
          ");");
      print("TB CREATED4");
    },
        onCreate: (Database db, int version) async {
      print('started');
      await db.execute("CREATE TABLE IF NOT EXISTS images("
          "imageId INTEGER PRIMARY KEY,"
          "imagePath STRING NOT NULL,"
          "FK_image_tags INTEGER NOT NULL,"
          "FOREIGN KEY (FK_image_tags) REFERENCES tager (tagId)"
          ");");
      print('success 1...');
      await db.execute("CREATE TABLE IF NOT EXISTS tager("
          "tagId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "tagName STRING NOT NULL,"
          "unique(tagName)"
          ");");
      print('success 2...');
      await db.execute("CREATE TABLE IF NOT EXISTS transactions("
            "FtagId INTEGER NOT NULL,"
            "FimageId INTEGER NOT NULL,"
            "FOREIGN KEY (FtagId) REFERENCES tager (tagId),"
            "FOREIGN KEY (FimageId) REFERENCES images (imageId)"
            ");");
        print('success 3...');
    });
  }
}
