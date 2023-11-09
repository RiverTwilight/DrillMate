import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/services/database.dart';

class BookmarkDatabase extends AppDatabase {
  static final BookmarkDatabase instance = BookmarkDatabase._init();

  BookmarkDatabase._init();

  Future<Bookmark> createBookmark(Bookmark bookmark) async {
    final db = await instance.database;

    await db.insert('bookmarks', bookmark.toJson());
    return bookmark;
  }

  Future<Bookmark> readBookmark(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      'bookmarks',
      columns: [
        'id',
        'title',
        'note',
        'videoId',
        'startAt',
        'endAt',
        'tags',
        'createDate',
        'updateDate',
        'favorite'
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

  Future<List<Bookmark>> readAllBookmarks() async {
    final db = await instance.database;
    final orderBy = 'id ASC';

    final result = await db.query('bookmarks', orderBy: orderBy);

    return result.map((json) => Bookmark.fromJson(json)).toList();
  }

  Future<int> updateBookmark(Bookmark bookmark) async {
    final db = await instance.database;

    return db.update(
      'bookmarks',
      bookmark.toJson(),
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }

  Future<int> deleteBookmark(String id) async {
    final db = await instance.database;

    return await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
