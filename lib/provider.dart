import 'package:hgeology_app/provider/collection_provider.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/provider/bookmark_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoProvider = ChangeNotifierProvider((ref) => VideoNotifer());
final collectionProvider =
    ChangeNotifierProvider((ref) => CollectionNotifier());
final bookmarkProvider = ChangeNotifierProvider((ref) => BookmarkNotifier());
final userDataProvider = ChangeNotifierProvider((ref) => DataProvider());
// final authProvider = ChangeNotifierProvider((ref) => AuthProvider());
