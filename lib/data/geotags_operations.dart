import 'dart:developer';

import 'package:photomaster/data/database.dart';
import 'package:photomaster/models/geotag.dart';
import 'database.dart';
import 'package:photomaster/models/image.dart';

class GeotagsOperations {
  GeotagsOperations geotagsOperations;

  final dbProvider = DatabaseRepository.instance;

  createGeoTag(Geotag geotag) async {
    final db = await dbProvider.database;
    db.insert('geotag', geotag.toMap());
  }

  Future<List<Geotag>> getAllGeoTags() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('geotag');
    List<Geotag> geotag = allRows.map((geotag) => Geotag.fromMap(geotag)).toList();
    return geotag;
  }
}
