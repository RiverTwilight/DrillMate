import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hgeology_app/utils/youtube_utils.dart';
import 'package:hgeology_app/widget/bilibili_player_flutter/bilibili_player_flutter.dart';
import 'dart:io';

String extractBVCode(String url) {
  final RegExp regExp = RegExp(r'(BV\w+)', caseSensitive: false);
  final match = regExp.firstMatch(url);
  return match?.group(0) ?? '';
}

enum MediaType {
  youtube,
  bilibili,
  localAudio,
  localVideo,
  remoteAudio,
  remoteVideo
}

/// Provide unfied API for [YoutubePlayerController], [VideoPlayerController], [AudioPlayer] and [BilibiliPlayerController]
class MediaController {
  late YoutubePlayerController _youtubeController;
  late BilibiliPlayerController _bilibiliPlayer;
  late VideoPlayerController _localVideoController;
  late AudioPlayer _localAudioController;

  late MediaType _mediaType;
  late bool _enableDanmuku;

  bool _isPlaying = false;

  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  bool _isAudioReady = false;

  MediaController(this._mediaType, this._enableDanmuku);

  dynamic get activeController {
    switch (_mediaType) {
      case MediaType.youtube:
        return _youtubeController;
      case MediaType.localVideo || MediaType.remoteVideo:
        return _localVideoController;
      case MediaType.localAudio || MediaType.remoteAudio:
        return _localVideoController;
      // return _localAudioController;
      case MediaType.bilibili:
        return _bilibiliPlayer;
      default:
        return _localVideoController;
    }
  }

  int get totalDurationInSeconds {
    switch (_mediaType) {
      case MediaType.youtube:
        return _youtubeController.metadata.duration.inSeconds;
      case MediaType.localVideo ||
            MediaType.remoteAudio ||
            MediaType.remoteVideo:
        return _localVideoController.value.duration.inSeconds;
      case MediaType.localAudio:
        return _localVideoController.value.duration.inSeconds;
      // return _audioDuration.inSeconds;
      case MediaType.bilibili:
        return _bilibiliPlayer.metadata.duration.inSeconds;
      default:
        return _audioDuration.inSeconds;
    }
  }

  Future<void> initialize(String sourceUrl) async {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController = YoutubePlayerController(
          initialVideoId: extractYoutubeVideoId(sourceUrl),
          flags: const YoutubePlayerFlags(
            hideThumbnail: true,
            autoPlay: false,
            mute: false,
          ),
        );
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController = VideoPlayerController.file(File(sourceUrl));
        await _localVideoController.initialize();
        _localVideoController.setLooping(true);
      case MediaType.remoteAudio:
        _localVideoController =
            VideoPlayerController.networkUrl(Uri.parse(sourceUrl));
        await _localVideoController.initialize();
        _localVideoController.setLooping(true);
      case MediaType.localAudio || MediaType.remoteAudio:
        // _localAudioController = AudioPlayer();
        // print(AssetSource(sourceUrl));
        // await _localAudioController.setSource(AssetSource(sourceUrl));
        // // await _localAudioController.setSource(
        // //     UrlSource(sourceUrl));
        // _localAudioController.onDurationChanged.listen((duration) {
        //   _audioDuration = duration;
        // });
        _localVideoController = VideoPlayerController.file(File(sourceUrl));
        await _localVideoController.initialize();
        _localVideoController.setLooping(true);
      case MediaType.bilibili:
        _bilibiliPlayer = BilibiliPlayerController(
          initialVideoId: extractBVCode(sourceUrl),
          flags: BilibiliPlayerFlags(
            hideThumbnail: true,
            autoPlay: false,
            mute: false,
            forceHD: true,
            enableDanmuku: _enableDanmuku,
          ),
        );
    }
  }

  int get currentPositionInSeconds {
    switch (_mediaType) {
      case MediaType.youtube:
        return _youtubeController.value.position.inSeconds;
      case MediaType.localVideo || MediaType.remoteAudio:
        return _localVideoController.value.position.inSeconds;
      case MediaType.localAudio:
        return _localVideoController.value.position.inSeconds;
      // return _audioPosition.inSeconds;
      case MediaType.bilibili:
        return _bilibiliPlayer.value.position.inSeconds;
      default:
        return 0;
    }
  }

  double get aspectRatio {
    switch (_mediaType) {
      case MediaType.youtube:
        return 16 / 9;
      case MediaType.localVideo:
        return _localVideoController.value.aspectRatio;
      case MediaType.localAudio:
        return 1.0;
      case MediaType.bilibili:
        return 16 / 9;
      default:
        return 1.0;
    }
  }

  bool get isInitialized {
    switch (_mediaType) {
      case MediaType.youtube:
        return _youtubeController.value.isReady;
      case MediaType.localVideo || MediaType.remoteVideo:
        return _localVideoController.value.isInitialized;
      case MediaType.localAudio || MediaType.remoteAudio:
        return _localVideoController.value.isInitialized;
      // return _isAudioReady;
      case MediaType.bilibili:
        return _bilibiliPlayer.value.isReady;
    }
  }

  void play() {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController.play();
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController.play();
      case MediaType.localAudio || MediaType.remoteAudio:
        _localVideoController.play();
      // _localAudioController.resume();
      case MediaType.bilibili:
        return _bilibiliPlayer.play();
    }
  }

  void pause() {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController.pause();
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController.pause();
      case MediaType.localAudio || MediaType.remoteAudio:
        _localVideoController.pause();
      // _localAudioController.pause();
      case MediaType.bilibili:
        return _bilibiliPlayer.pause();
    }
  }

  void seekTo(Duration position) {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController.seekTo(position);
      case MediaType.bilibili:
        return _bilibiliPlayer.seekTo(position);
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController.seekTo(position);
      case MediaType.localAudio || MediaType.remoteAudio:
        _localVideoController.seekTo(position);
      // _localAudioController.seek(position);
    }
  }

  void addListener(VoidCallback listener) {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController.addListener(listener);
      case MediaType.bilibili:
        _bilibiliPlayer.addListener(listener);
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController.addListener(listener);
      case MediaType.localAudio || MediaType.remoteAudio:
        _localVideoController.addListener(listener);
      // _localAudioController.onPositionChanged.listen((position) {
      //   _audioPosition = position;
      //   listener();
      // });
    }
  }

  void dispose() {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController.dispose();
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController.dispose();
      case MediaType.localAudio || MediaType.remoteAudio:
        _localVideoController.dispose();
      // _localAudioController.dispose();
      case MediaType.bilibili:
        return _bilibiliPlayer.dispose();
    }
  }

  void setPlaybackSpeed(double rate) {
    switch (_mediaType) {
      case MediaType.youtube:
        _youtubeController.setPlaybackRate(rate);
      case MediaType.localVideo || MediaType.remoteVideo:
        _localVideoController.setPlaybackSpeed(rate);
      case MediaType.localAudio || MediaType.remoteAudio:
        _localVideoController.setPlaybackSpeed(rate);
      // _localAudioController.setPlaybackRate(rate);
      case MediaType.bilibili:
        return _bilibiliPlayer.setPlaybackRate(rate);
    }
  }

  bool get isPlaying {
    switch (_mediaType) {
      case MediaType.youtube:
        return _youtubeController.value.isPlaying;
      case MediaType.localVideo || MediaType.remoteVideo:
        return _localVideoController.value.isPlaying;
      case MediaType.localAudio || MediaType.remoteAudio:
        return _localVideoController.value.isPlaying;
      // return _isAudioReady;
      case MediaType.bilibili:
        return _bilibiliPlayer.value.isPlaying;
    }
  }
}
