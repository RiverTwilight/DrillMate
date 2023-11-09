import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:hgeology_app/models/bookmark.dart';

Future<List<Bookmark>> convertSrtToBookmarks(
    String srtFilePath, String videoId) async {
  final fileContent = await rootBundle.loadString(srtFilePath);
  final lines = fileContent.split('\n');

  final bookmarks = <Bookmark>[];
  final uuid = Uuid();

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();

    if (line.isNotEmpty) {
      final number = int.parse(line);
      final timecodes = lines[i + 1].split(' --> ');
      final startAt = _timecodeToSeconds(timecodes[0]);
      final endAt = _timecodeToSeconds(timecodes[1]);
      final text = lines[i + 2];

      i += 3; // Skip to the next subtitle entry
    }
  }

  return bookmarks;
}

int _timecodeToSeconds(String timecode) {
  final parts = timecode.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = double.parse(parts[2]);

  return (hours * 3600 + minutes * 60 + seconds).round();
}
