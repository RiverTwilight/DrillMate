import 'dart:math';
import 'package:hgeology_app/services/database_handler.dart';

class Project implements AppDatabaseEntity {
  final String id;
  final String title;
  final String note;
  final String videoId;
  final int startAt;
  final int endAt;
  final List<String> tags;
  final String createDate;
  final String updateDate;
  final bool favorite;

  Project({
    required this.id,
    required this.title,
    required this.note,
    required this.videoId,
    required this.startAt,
    required this.endAt,
    required this.tags,
    required this.createDate,
    required this.updateDate,
    required this.favorite,
  });

  String get rawNote {
    return note
        .replaceAll(RegExp(r'\n|\*|_|#'), '')
        .substring(0, min(30, note.length));
  }

  Project copy({
    String? id,
    String? title,
    String? note,
    String? videoId,
    int? startAt,
    int? endAt,
    List<String>? tags,
    String? createDate,
    String? updateDate,
    bool? favorite,
  }) =>
      Project(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
        videoId: videoId ?? this.videoId,
        startAt: startAt ?? this.startAt,
        endAt: endAt ?? this.endAt,
        tags: tags ?? this.tags,
        createDate: createDate ?? this.createDate,
        updateDate: updateDate ?? this.updateDate,
        favorite: favorite ?? this.favorite,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'videoId': videoId,
        'startAt': startAt,
        'endAt': endAt,
        'tags': tags.join(","),
        'createDate': createDate,
        'updateDate': updateDate,
        'favorite': favorite ? 1 : 0,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        title: json['title'],
        note: json['note'],
        videoId: json['videoId'],
        startAt: json['startAt'],
        endAt: json['endAt'],
        tags: json['tags'].split(","),
        createDate: json['createDate'],
        updateDate: json['updateDate'],
        favorite: json['favorite'] == 1,
      );
}
