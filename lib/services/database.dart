import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const _dbFileName = 'talkreel-1.0.10.db';
const iCloudContainerId = 'iCloud.com.rivertwilight.talkreel';
const collectionsDBName = 'collections';
const bookmarkDBName = 'bookmarks';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  String getCloudFilePath(String version) {
    return '$version/$_dbFileName';
  }

  // Database get db => _database!;

  AppDatabase._init();

  AppDatabase();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbFileName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1, // Update this to the new version number
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion <= 3) {
    //   await db.execute('''
    //   CREATE TABLE collections (
    //     id TEXT NOT NULL PRIMARY KEY,
    //     title TEXT NOT NULL,
    //     description TEXT,
    //     icon TEXT
    //   )
    // ''');
    //   // If there are more changes for further versions, handle them with additional if statements.
    // }
    // Implement other version upgrades with additional if statements here.
  }

  Future<void> wipeData() async {
    await _database!.delete('medias');
    await _database!.delete('bookmarks');
    // await _database!.delete('review_logs');
  }

  // Future<void> uploadToICloud(
  //   String version,
  //   StreamController controller,
  // ) async {
  //   final completer = Completer<void>();

  //   final dbPath = await getDatabasesPath();
  //   final localFilePath = join(dbPath, _dbFileName);

  //   await ICloudStorage.upload(
  //     containerId: iCloudContainerId,
  //     destinationRelativePath: getCloudFilePath(version),
  //     filePath: localFilePath,
  //     onProgress: (stream) {
  //       stream.listen(
  //         (progress) {
  //           controller.add(progress);
  //         },
  //         onDone: () {
  //           completer.complete();
  //         },
  //         onError: (err) {
  //           completer.completeError(err);
  //         },
  //         cancelOnError: true,
  //       );
  //     },
  //   );

  //   return completer.future;
  // }

  // Future<void> downloadFromICloud(
  //   String version,
  //   StreamController controller,
  //   VoidCallback onDataReload,
  // ) async {
  //   final completer = Completer<void>();
  //   final dbPath = await getDatabasesPath();
  //   final localFilePath = join(dbPath, _dbFileName);
  //   final cloudFilePath = getCloudFilePath(version);

  //   await ICloudStorage.download(
  //     containerId: iCloudContainerId,
  //     relativePath: cloudFilePath,
  //     destinationFilePath: localFilePath,
  //     onProgress: (stream) {
  //       stream.listen(
  //         (progress) {
  //           controller.add(progress);
  //         },
  //         onDone: () async {
  //           await _database?.close(); // Close the existing database
  //           _database = null; // Nullify the database instance
  //           await _initDB(_dbFileName); // Reinitialize the database
  //           onDataReload();
  //           completer.complete();
  //         },
  //         onError: (err) {
  //           completer.completeError(err);
  //         },
  //         cancelOnError: true,
  //       );
  //     },
  //   );

  //   return completer.future;
  // }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT NOT NULL PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const booleanType =
        'INTEGER NOT NULL'; // SQLite uses INTEGER to store boolean values

    await db.execute('''
      CREATE TABLE bookmarks ( 
        id $idType, 
        title $textType,
        note $textType,
        videoId $textType,
        startAt $integerType,
        endAt $integerType,
        tags $textType,
        createDate $textType,
        updateDate $textType,
        favorite $booleanType
      )
  ''');

    await db.execute('''
      CREATE TABLE medias ( 
        id $textType, 
        title $textType,
        thumbnailUrl $textType,
        creationDate $textType,
        lastOpendedDate $textType,
        sourceUrl $textType,
        lastPlayPosition $integerType DEFAULT 0,
        subtitles $textType
      )
  ''');

    await db.execute('''
      CREATE TABLE review_logs ( 
        id $textType, 
        mediaId $textType, 
        bookmarkId $textType, 
        recordUrl $textType, 
        createDate $textType
      )
  ''');
  }
}
