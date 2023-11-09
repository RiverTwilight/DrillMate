import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/review_log.dart';
import 'package:flutter/foundation.dart';
import 'package:hgeology_app/services/database/reviewLogs_database.dart';
import 'package:uuid/uuid.dart';

final reviewLogsProvider = ChangeNotifierProvider((ref) => ReviewLogNotifier());

class ReviewLogNotifier extends ChangeNotifier {
  final _reviewLogsDb = ReviewLogsDatabase.instance;

  List<ReviewLog> _logs = [];

  ReviewLogNotifier() : super();

  List<ReviewLog> get logs => _logs;

  Future<void> loadData() async {
    _logs = await _reviewLogsDb.readAll();
    notifyListeners();
  }

  Future<void> addLog({
    required String mediaId,
    required String bookmarkId,
    required String recordUrl,
  }) async {
    print("Creating");

    final now = DateTime.now().toIso8601String();
    final log = ReviewLog(
      id: Uuid().v4(),
      mediaId: mediaId,
      bookmarkId: bookmarkId,
      recordUrl: recordUrl,
      createDate: now,
    );

    await _reviewLogsDb.create(log);
    loadData();
  }
}
