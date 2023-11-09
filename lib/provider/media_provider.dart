import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/services/database/video_database.dart';
import 'package:flutter/foundation.dart';

class VideoNotifer extends ChangeNotifier {
  final _videoDb = VideoDatabase.instance;
  List<Video> _videos = [];

  VideoNotifer() : super();

  List<Video> get videos => _videos;

  Future<void> loadData() async {
    _videos = await _videoDb.getAllVideos();
    notifyListeners();
  }

  Video getVideo(String videoId) {
    Video videoInfo = _videos.firstWhere((element) => element.id == videoId);
    return videoInfo;
  }

  Future<void> addVideo(Video video) async {
    print("trying to add ${video.id}");
    await _videoDb.createVideo(video);
    loadData();
  }

  void deleteVideo(String id) async {
    await _videoDb.deleteVideo(id);
    loadData();
  }

  List<Video> searchByName(String query) {
    List<Video> searchResult = _videos
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return searchResult;
  }

  Future<void> updateVideo(Video video) async {
    await _videoDb.updateVideo(video);
    loadData();
  }
}
