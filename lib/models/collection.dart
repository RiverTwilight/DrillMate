import 'package:hgeology_app/services/database_handler.dart';

class Collection implements AppDatabaseEntity {
  @override
  final String id;
  final String title;
  final String description;
  final String icon;

  Collection({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  Collection.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        icon = json['icon'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
      };
}
