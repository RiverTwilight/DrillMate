import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

abstract class Identifiable {
  String get id;
}

class StoragedStateProvider<T extends Identifiable> extends ChangeNotifier {
  final String storageName;
  late List<T> storageContent = [];

  StoragedStateProvider({required this.storageName});

  void _add(T data) {
    storageContent.add(data);
    saveToLocal();
  }

  @protected
  void addData(T data) {
    _add(data);
  }

  void _delete(dynamic data) {
    if (data is T) {
      storageContent.removeWhere((element) => element.id == data.id);
    } else if (data is String) {
      storageContent.removeWhere((element) => element.id == data);
    } else {
      throw ArgumentError('Unsupported argument type ${data.runtimeType}');
    }
    saveToLocal();
  }

  @protected
  void deleteData(dynamic data) {
    _delete(data);
  }

  void _modify(T data) {
    int index = storageContent.indexWhere((element) => element.id == data.id);
    if (index != -1) {
      storageContent[index] = data;
      saveToLocal();
    }
  }

  @protected
  void modifyData(T data) {
    _modify(data);
  }

  T _get(String id) {
    return storageContent.firstWhere((element) => element.id == id);
  }

  @protected
  T getData(String id) {
    return _get(id);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$storageName.json');
  }

  @protected
  Future<File> saveToLocal() async {
    final file = await _localFile;

    if (!file.existsSync()) {
      file.createSync();
    }

    String savableStr = json.encode(storageContent);

    // print("Saved str: ${savableStr}");

    return file.writeAsString(savableStr);
  }

  Future<Iterable> readFromLocal() async {
    try {
      final file = await _localFile;

      print(file);

      if (!file.existsSync()) {
        return [];
      }

      String contents = await file.readAsString();

      print("Readed str: ${contents}");

      Iterable json = jsonDecode(contents);

      return json;
    } catch (e) {
      return [];
    }
  }
}
