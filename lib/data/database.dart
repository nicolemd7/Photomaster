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
      await db.execute("DROP TABLE IF EXISTS images;");
      await db.execute("DROP TABLE IF EXISTS transactions;");

      await db.execute("CREATE TABLE IF NOT EXISTS images("
          "imageId STRING PRIMARY KEY,"
          "imagePath STRING NOT NULL"
          ");");
      await db.execute("CREATE TABLE IF NOT EXISTS transactions("
          "FtagId INTEGER NOT NULL,"
          "FimageId STRING NOT NULL,"
          "FOREIGN KEY (FtagId) REFERENCES tager(tagId),"
          "FOREIGN KEY (FimageId) REFERENCES images(imageId)"
          ");");
      print("TB CREATED1");
      // THIS IS CAUSING ISSUE
      await db.execute("CREATE TABLE IF NOT EXISTS tager("
          " tagId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "tagName STRING NOT NULL,"
          "unique(tagName)"
          "  );");
      print("TB CREATED2");
      await db.execute("CREATE TABLE IF NOT EXISTS geotag("
          "id INTEGER NOT NULL,"
          "lat FLOAT NOT NULL,"
          "long FLOAT NOT NULL"
          ");");
      print("geotag table created");
    },
        onCreate: (Database db, int version) {});
  }
}
