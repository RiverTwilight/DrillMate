import 'package:hgeology_app/models/collection.dart';
import 'package:hgeology_app/services/database.dart';
import 'package:hgeology_app/services/database_handler.dart';
import 'package:flutter/foundation.dart';

class ProjectNotifier extends ChangeNotifier {
  final AppDatabaseHandler<Collection> _dbHandler;

  List<Collection> _collections = [];

  ProjectNotifier()
      : _dbHandler = AppDatabaseHandler<Collection>(
          dbName: collectionsDBName,
          queryColumns: ['id', 'title', 'icon', 'description'],
          fromJson: Collection.fromJson,
        ),
        super();

  List<Collection> get collections => _collections;

  Future<void> loadData() async {
    _collections = await _dbHandler.readAll();
    notifyListeners();
  }

  Future<void> createCollection({
    String? id,
    String? title,
    String description = "",
    String icon = "",
  }) async {
    final now = DateTime.now().toIso8601String();

    final collection = Collection(
      id: id!,
      title: title!,
      description: description,
      icon: icon,
    );
    await _dbHandler.create(collection);

    loadData();
  }

  Collection getCollectionById(String id) {
    return _collections.firstWhere((bookmark) => bookmark.id == id);
  }

  Future<void> deleteCollection(String id) async {
    await _dbHandler.delete(id);
    loadData();
  }

  Future<void> updateCollection(Collection collection) async {
    await _dbHandler.update(collection);
    loadData();
  }
}
