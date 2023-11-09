import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/models/review_log.dart';
import 'package:hgeology_app/services/database.dart';

class ReviewLogsDatabase extends AppDatabase {
  static final ReviewLogsDatabase instance = ReviewLogsDatabase._init();

  ReviewLogsDatabase._init();

  Future<ReviewLog> create(ReviewLog log) async {
    final db = await instance.database;

    await db.insert('review_logs', log.toJson());
    return log;
  }

  Future<Bookmark> read(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      'review_logs',
      columns: [
        'id',
        'mediaId',
        'bookmarkId',
        'recordUrl',
        'createDate',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Bookmark.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ReviewLog>> readAll() async {
    final db = await instance.database;
    final orderBy = 'id ASC';

    final result = await db.query('review_logs', orderBy: orderBy);

    return result.map((json) => ReviewLog.fromJson(json)).toList();
  }
}
