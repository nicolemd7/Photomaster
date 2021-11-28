import 'package:moor_flutter/moor_flutter.dart';

part 'tagging_database.g.dart';

class Paths extends Table {
  // autoincrement sets this to the primary key automatically
  IntColumn get id => integer().autoIncrement()();
  // TextColumn get tagName =>
  //     text().nullable().customConstraint('NULL REFERENCES tags(name)')();
  TextColumn get paths => text()();
}

// class Tags extends Table {
//   TextColumn get name => text().call();

//   @override
//   Set<Column> get primaryKey => {name};
// }

@UseMoor(tables: [Paths])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true,
        )));

  @override
  // Bump this when changing tables and columns.
  int get schemaVersion => 1;

  // All tables have getters in the generated class - we can select the tasks table
  Future<List<Path>> getAllPaths() => select(paths).get();

  // Moor supports Streams which emit elements when the watched data changes
  Stream<List<Path>> watchallPaths() => select(paths).watch();

  Future insertPath(Path path) => into(paths).insert(path);

  // Updates a Task with a matching primary key
  Future updatePath(Path path) => update(paths).replace(path);

  Future deleteTask(Path path) => delete(paths).delete(path);
}
