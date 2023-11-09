import 'package:hgeology_app/services/database.dart';

class AppDatabaseHandler<T extends AppDatabaseEntity> {
  final String dbName;
  final List<String> queryColumns;
  final T Function(Map<String, dynamic>) fromJson;

  AppDatabaseHandler({
    required this.dbName,
    required this.queryColumns,
    required this.fromJson,
  });

  Future<T> create(T entity) async {
    final db = await AppDatabase.instance.database;

    await db.insert(dbName, entity.toJson());
    return entity;
  }

  Future<T> read(String id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      dbName,
      columns: queryColumns,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<T>> readAll() async {
    final db = await AppDatabase.instance.database;
    final orderBy = 'id ASC';

    final result = await db.query(dbName, orderBy: orderBy);

    return result.map((json) => fromJson(json)).toList();
  }

  Future<int> update(T entity) async {
    final db = await AppDatabase.instance.database;

    return db.update(
      dbName,
      entity.toJson(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      dbName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

abstract class AppDatabaseEntity {
  Map<String, dynamic> toJson();
  String get id;
}
