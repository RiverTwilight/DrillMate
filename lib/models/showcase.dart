import 'dart:convert';
import 'package:hgeology_app/models/bookmark.dart';

class Showcase {
  final String title;
  final String description;
  final String coverUrl;
  final String sourceUrl;
  final String authorId;
  final DateTime createDate;
  final List<Bookmark> bookmarks;
  final List<String> tags;
  final int likes;

  Showcase({
    required this.title,
    required this.description,
    required this.tags,
    required this.bookmarks,
    required this.coverUrl,
    required this.sourceUrl,
    required this.authorId,
    required this.createDate,
    this.likes = 0,
  });

  factory Showcase.fromDatabaseJson(Map<String, dynamic> json) {
    return Showcase(
      title: json['title'],
      description: json['description'],
      sourceUrl: json['source_url'],
      coverUrl: "xxxxx",
      authorId: json['author_uid'],
      createDate: DateTime.parse(json['created_at']),
      tags: List<String>.from(jsonDecode(json['tags']) as List),
      bookmarks: (jsonDecode(json['bookmarks'] as String) as List)
          .map((item) => Bookmark.fromJson(item as Map<String, dynamic>))
          .toList(),
      likes: json['likes'] ?? 0,
    );
  }
}
