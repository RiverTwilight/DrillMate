import 'package:flutter/services.dart';

const channel = MethodChannel('speech_to_text');

Future<List<Map<String, dynamic>>?> transcribeAudio(String path,
    {String? languageCode}) async {
  final result = await channel.invokeMethod(
    'transcribeAudio',
    {
      'path': path,
      'languageCode': languageCode ?? 'en-US',
    },
  );

  return result != null
      ? List<Map<String, dynamic>>.from(
          (result as List).map(
            (item) => Map<String, dynamic>.from(item as Map),
          ),
        )
      : null;
}

String getTextForTimeInterval(
    double startTime, double endTime, List<Map<String, dynamic>> subtitles) {
  List<String> words = [];

  for (var subtitle in subtitles) {
    if (subtitle['start'] >= startTime && subtitle['end'] <= endTime) {
      words.add(subtitle['text']);
    }
  }

  return words.join(' ');
}

String getFullText(List<Map<String, dynamic>> subtitles) {
  List<String> words = [];

  for (var subtitle in subtitles) {
    words.add(subtitle['text']);
  }

  return words.join(' ');
}
