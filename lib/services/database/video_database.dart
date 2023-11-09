import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/services/database.dart';

const _mediaDbKey = "medias";

class VideoDatabase extends AppDatabase {
  static final VideoDatabase instance = VideoDatabase._init();

  VideoDatabase._init();

  Future<Video> createVideo(Video video) async {
    final db = await instance.database;
    await db.insert('medias', video.toJson());
    return video.copy();
  }

  Future<Video> readVideo(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      _mediaDbKey,
      columns: [
        'id',
        'title',
        'thumbnailUrl',
        'creationDate',
        'lastOpendedDate',
        'sourceUrl',
        'lastPlayPosition',
        'subtitles',
        'collections'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Video.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Video>> getAllVideos() async {
    final db = await instance.database;

    const orderBy = 'creationDate ASC';

    final result = await db.query(_mediaDbKey, orderBy: orderBy);

    return result.map((json) => Video.fromJson(json)).toList();
  }

  Future<int> updateVideo(Video video) async {
    final db = await instance.database;

    return db.update(
      _mediaDbKey,
      video.toJson(),
      where: 'id = ?',
      whereArgs: [video.id],
    );
  }

  Future<int> deleteVideo(String id) async {
    final db = await instance.database;

    return await db.delete(
      _mediaDbKey,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
