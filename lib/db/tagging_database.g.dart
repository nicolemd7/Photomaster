// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagging_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Path extends DataClass implements Insertable<Path> {
  final int id;
  final String paths;
  Path({@required this.id, @required this.paths});
  factory Path.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Path(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      paths: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}paths']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || paths != null) {
      map['paths'] = Variable<String>(paths);
    }
    return map;
  }

  PathsCompanion toCompanion(bool nullToAbsent) {
    return PathsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      paths:
          paths == null && nullToAbsent ? const Value.absent() : Value(paths),
    );
  }

  factory Path.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Path(
      id: serializer.fromJson<int>(json['id']),
      paths: serializer.fromJson<String>(json['paths']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paths': serializer.toJson<String>(paths),
    };
  }

  Path copyWith({int id, String paths}) => Path(
        id: id ?? this.id,
        paths: paths ?? this.paths,
      );
  @override
  String toString() {
    return (StringBuffer('Path(')
          ..write('id: $id, ')
          ..write('paths: $paths')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, paths);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Path && other.id == this.id && other.paths == this.paths);
}

class PathsCompanion extends UpdateCompanion<Path> {
  final Value<int> id;
  final Value<String> paths;
  const PathsCompanion({
    this.id = const Value.absent(),
    this.paths = const Value.absent(),
  });
  PathsCompanion.insert({
    this.id = const Value.absent(),
    @required String paths,
  }) : paths = Value(paths);
  static Insertable<Path> custom({
    Expression<int> id,
    Expression<String> paths,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paths != null) 'paths': paths,
    });
  }

  PathsCompanion copyWith({Value<int> id, Value<String> paths}) {
    return PathsCompanion(
      id: id ?? this.id,
      paths: paths ?? this.paths,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paths.present) {
      map['paths'] = Variable<String>(paths.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PathsCompanion(')
          ..write('id: $id, ')
          ..write('paths: $paths')
          ..write(')'))
        .toString();
  }
}

class $PathsTable extends Paths with TableInfo<$PathsTable, Path> {
  final GeneratedDatabase _db;
  final String _alias;
  $PathsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _pathsMeta = const VerificationMeta('paths');
  GeneratedColumn<String> _paths;
  @override
  GeneratedColumn<String> get paths =>
      _paths ??= GeneratedColumn<String>('paths', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, paths];
  @override
  String get aliasedName => _alias ?? 'paths';
  @override
  String get actualTableName => 'paths';
  @override
  VerificationContext validateIntegrity(Insertable<Path> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('paths')) {
      context.handle(
          _pathsMeta, paths.isAcceptableOrUnknown(data['paths'], _pathsMeta));
    } else if (isInserting) {
      context.missing(_pathsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Path map(Map<String, dynamic> data, {String tablePrefix}) {
    return Path.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PathsTable createAlias(String alias) {
    return $PathsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PathsTable _paths;
  $PathsTable get paths => _paths ??= $PathsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [paths];
}
