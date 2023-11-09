import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/services/database.dart';
import 'package:hgeology_app/services/database_handler.dart';
import 'package:flutter/foundation.dart';

class BookmarkNotifier extends ChangeNotifier {
  final AppDatabaseHandler<Bookmark> _bookmarkDbHandler;

  List<Bookmark> _bookmarks = [];

  BookmarkNotifier()
      : _bookmarkDbHandler = AppDatabaseHandler<Bookmark>(
          dbName: bookmarkDBName,
          queryColumns: [
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
          fromJson: Bookmark.fromJson,
        ),
        super();

  List<Bookmark> get bookmarks => _bookmarks;

  Future<void> loadData() async {
    _bookmarks = await _bookmarkDbHandler.readAll();
    notifyListeners();
  }

  Future<void> addBookmark({
    String? id,
    String? title,
    String? note,
    String? videoId,
    int? startAt,
    int? endAt,
    List<String>? tags,
    bool favorite = false,
    List<Bookmark>? bookmarks,
  }) async {
    final now = DateTime.now().toIso8601String();

    // Handle single bookmark
    if (bookmarks == null) {
      final bookmark = Bookmark(
        id: id!,
        title: title!,
        note: note!,
        videoId: videoId!,
        startAt: startAt!,
        endAt: endAt!,
        tags: tags!,
        createDate: now,
        updateDate: now,
        favorite: favorite,
      );
      await _bookmarkDbHandler.create(bookmark);
    }
    // Handle list of bookmarks
    else {
      for (var bookmark in bookmarks) {
        await _bookmarkDbHandler.create(bookmark);
      }
    }

    loadData();
  }

  List<Bookmark> searchByContent(String query) {
    if (query == "") return [];

    return _bookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
          bookmark.note.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Bookmark getBookmarkById(String id) {
    return _bookmarks.firstWhere((bookmark) => bookmark.id == id);
  }

  List<Bookmark> getAllBookmarkByMedia(String mediaId) {
    return _bookmarks.where((bookmark) => bookmark.videoId == mediaId).toList();
  }

  Future<void> removeBookmark(String id) async {
    await _bookmarkDbHandler.delete(id);
    loadData();
  }

  Future<void> favoriteBookmark(String id) async {
    final bookmark = _bookmarks.firstWhere((bookmark) => bookmark.id == id);
    await _bookmarkDbHandler
        .update(bookmark.copy(favorite: !bookmark.favorite));
    loadData();
  }

  Future<void> removeBookmarkByMedia(String videoId) async {
    bookmarks.forEach((element) async {
      if (element.videoId == videoId) {
        await _bookmarkDbHandler.delete(element.id);
      }
    });
    loadData();
  }

  Future<void> updateBookmark(Bookmark bookmark) async {
    await _bookmarkDbHandler.update(bookmark);
    loadData();
  }

  List<String> get allTags {
    Set<String> allTags = {};

    for (var bookmark in _bookmarks) {
      if (bookmark.tags.isNotEmpty) {
        allTags.addAll(bookmark.tags);
      }
    }

    List<String> res = allTags.toList();

    res.removeWhere((element) => element.isEmpty);

    return res;
  }
}
