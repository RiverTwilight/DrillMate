import 'dart:convert';

import 'package:hgeology_app/services/media_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Video {
  final String id;
  final String title;
  final String sourceUrl;
  final String thumbnailUrl;
  final DateTime createDate;
  final DateTime lastOpendedDate;
  final int lastPlayPosition;
  final List<Map<String, dynamic>> subtitles;
  final List<String> collections; // New field to store collection IDs

  Video({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.thumbnailUrl,
    required this.createDate,
    required this.lastOpendedDate,
    this.lastPlayPosition = 0,
    this.subtitles = const [],
    this.collections = const [], // Initialize with an empty list by default
  });

  Future<String> get loadablePath async {
    if (sourceUrl.startsWith("https")) {
      return sourceUrl;
    }

    final fileName = p.basename(sourceUrl);
    final directory = await getApplicationDocumentsDirectory();
    return p.join(directory.path, fileName);
  }

  MediaType get mediaType {
    final uri = Uri.tryParse(sourceUrl);

    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
        return MediaType.youtube;
      } else if (uri.host.contains('bilibili.com')) {
        return MediaType.bilibili;
      } else if (sourceUrl.contains('.mp3')) {
        return MediaType.remoteAudio;
      } else {
        return MediaType.remoteVideo;
      }
    } else {
      if (sourceUrl.contains('.aac') ||
          sourceUrl.contains('.mp3') ||
          sourceUrl.contains('.m4a') ||
          sourceUrl.contains('.wav')) {
        return MediaType.localAudio;
      } else {
        return MediaType.localVideo;
      }
    }
  }

  dynamic get mediaIcon {
    if (mediaType == MediaType.bilibili) {
      return FontAwesomeIcons.bilibili;
    } else if (mediaType == MediaType.youtube) {
      return FontAwesomeIcons.youtube;
    } else if (mediaType == MediaType.localAudio) {
      return Icons.mic;
    } else {
      return Icons.videocam_rounded;
    }
  }

  Video copy({
    String? id,
    String? title,
    String? sourceUrl,
    String? thumbnailUrl,
    int? lastPlayPosition,
    DateTime? lastOpendedDate,
    List<Map<String, dynamic>>? subtitles,
    List<String>? collections, // Include collections in the copy method
  }) =>
      Video(
        id: id ?? this.id,
        title: title ?? this.title,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        createDate: createDate,
        lastOpendedDate: lastOpendedDate ?? this.lastOpendedDate,
        sourceUrl: sourceUrl ?? this.sourceUrl,
        lastPlayPosition: lastPlayPosition ?? this.lastPlayPosition,
        subtitles: subtitles ?? this.subtitles,
        collections: collections ??
            this.collections, // Assign the new or existing collections
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
        'creationDate': createDate.toIso8601String(),
        'lastOpendedDate': lastOpendedDate.toIso8601String(),
        'sourceUrl': sourceUrl,
        'lastPlayPosition': lastPlayPosition,
        'subtitles': jsonEncode(subtitles),
        'collections':
            jsonEncode(collections), // Encode the collections list to JSON
      };

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'],
        title: json['title'],
        thumbnailUrl: json['thumbnailUrl'],
        createDate: DateTime.parse(json['creationDate'] as String),
        lastOpendedDate: DateTime.parse(
            json['lastOpendedDate'] ?? json['creationDate'] as String),
        sourceUrl: json['sourceUrl'],
        lastPlayPosition: json['lastPlayPosition'] ?? 0,
        subtitles: (jsonDecode(json['subtitles'] as String) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        collections:
            (jsonDecode(json['collections'] as String? ?? '[]') as List)
                .map<String>((item) => item.toString())
                .toList(),
      );
}
