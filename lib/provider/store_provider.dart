import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/models/showcase.dart';

final storeProvider = ChangeNotifierProvider((ref) => StoreProvider());

class StoreProvider extends ChangeNotifier {
  final SupabaseQueryBuilder dbRef = Supabase.instance.client.from('showcase');

  List<Showcase> _cases = const [];

  bool _finishLoading = false;

  List<Showcase> get cases => _cases;
  bool get finishLoading => _finishLoading;

  Future<void> loadCases() async {
    _cases =
        (await _fetchCases()).map((e) => Showcase.fromDatabaseJson(e)).toList();

    notifyListeners();
  }

  Future<void> uploadCase(String uid, String title,
      {String description = 'No description',
      String sourceUrl = 'User_BD8CJO',
      List<Bookmark> bookmarks = const []}) async {
    Map<String, dynamic> caseData = {
      'title': title,
      'description': description,
      'author_uid': uid,
      'source_url': sourceUrl,
      'tags': "[]",
      'bookmarks': bookmarks.isEmpty
          ? "[]"
          : jsonEncode(bookmarks.map((b) => b.toJson()).toList())
    };

    await dbRef.insert([caseData]).then((value) => print("Success"));
  }

  Future<List<dynamic>> _fetchCases({List<String> tags = const []}) async {
    final querySnapshot = await dbRef.select();

    if (querySnapshot.isNotEmpty) {
      _finishLoading = true;
      return querySnapshot as List<dynamic>;
    } else {
      throw Exception('No user is currently signed in');
    }
  }
}
