import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../utils/bilibili_meta_data.dart';
import '../enums/player_state.dart';
import '../enums/playback_rate.dart';

/// [ValueNotifier] for [BilibiliPlayerController].
class BilibiliPlayerValue {
  /// The duration, current position, buffering state, error state and settings
  /// of a [BilibiliPlayerController].
  BilibiliPlayerValue({
    this.isReady = false,
    this.isControlsVisible = false,
    this.hasPlayed = false,
    this.position = const Duration(),
    this.buffered = 0.0,
    this.isPlaying = false,
    this.isFullScreen = false,
    this.volume = 100,
    this.playerState = PlayerState.unknown,
    this.playbackRate = PlaybackRate.normal,
    this.playbackQuality,
    this.errorCode = 0,
    this.webViewController,
    this.isDragging = false,
    this.metaData = const BilibiliMetaData(),
  });

  /// Returns true when the player is ready to play videos.
  final bool isReady;

  /// The current state of the player defined as [PlayerState].
  final PlayerState playerState;

  /// The current video playback rate defined as [PlaybackRate].
  final double playbackRate;

  /// Defines whether or not the controls are visible.
  final bool isControlsVisible;

  /// Returns true once the video start playing for the first time.
  final bool hasPlayed;

  /// The current position of the video.
  final Duration position;

  /// The position up to which the video is buffered.i
  final double buffered;

  /// Reports true if video is playing.
  final bool isPlaying;

  /// Reports true if video is fullscreen.
  final bool isFullScreen;

  /// The current volume assigned for the player.
  final int volume;

  /// The current state of the player defined as [PlayerState].
  // final PlayerState playerState;

  /// Reports the error code as described [here](https://developers.google.com/youtube/iframe_api_reference#Events).
  ///
  /// See the onError Section.
  final int errorCode;

  /// Reports the [WebViewController].
  final InAppWebViewController? webViewController;

  /// Returns true is player has errors.
  bool get hasError => errorCode != 0;

  /// Reports the current playback quality.
  final String? playbackQuality;

  /// Returns true if [ProgressBar] is being dragged.
  final bool isDragging;

  /// Returns meta data of the currently loaded/cued video.
  final BilibiliMetaData metaData;

  /// Creates new [YoutubePlayerValue] with assigned parameters and overrides
  /// the old one.
  BilibiliPlayerValue copyWith({
    bool? isReady,
    bool? isControlsVisible,
    bool? isLoaded,
    bool? hasPlayed,
    Duration? position,
    double? buffered,
    bool? isPlaying,
    bool? isFullScreen,
    int? volume,
    PlayerState? playerState,
    double? playbackRate,
    String? playbackQuality,
    int? errorCode,
    InAppWebViewController? webViewController,
    bool? isDragging,
    BilibiliMetaData? metaData,
  }) {
    return BilibiliPlayerValue(
      isReady: isReady ?? this.isReady,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      hasPlayed: hasPlayed ?? this.hasPlayed,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      isPlaying: isPlaying ?? this.isPlaying,
      playerState: playerState ?? this.playerState,
      playbackRate: playbackRate ?? this.playbackRate,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      volume: volume ?? this.volume,
      playbackQuality: playbackQuality ?? this.playbackQuality,
      errorCode: errorCode ?? this.errorCode,
      webViewController: webViewController ?? this.webViewController,
      isDragging: isDragging ?? this.isDragging,
      metaData: metaData ?? this.metaData,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'metaData: ${metaData.toString()}, '
        'isReady: $isReady, '
        'isControlsVisible: $isControlsVisible, '
        'position: ${position.inSeconds} sec. , '
        'buffered: $buffered, '
        'isPlaying: $isPlaying, '
        'volume: $volume, '
        'playbackQuality: $playbackQuality, '
        'errorCode: $errorCode)';
  }
}

class BilibiliPlayerFlags {
  /// If set to true, hides the controls.
  ///
  /// Default is false.
  final bool hideControls;

  /// Is set to true, controls will be visible at start.
  ///
  /// Default is false.
  final bool controlsVisibleAtStart;

  /// Define whether to auto play the video after initialization or not.
  ///
  /// Default is true.
  final bool autoPlay;

  /// Mutes the player initially
  ///
  /// Default is false.
  final bool mute;

  /// if true, Live Playback controls will be shown instead of default one.
  ///
  /// Default is false.
  final bool isLive;

  /// Hides thumbnail if true.
  ///
  /// Default is false.
  final bool hideThumbnail;

  /// Disables seeking video position when dragging horizontally.
  ///
  /// Default is false.
  final bool disableDragSeek;

  /// Enabling this causes the player to play the video again and again.
  ///
  /// Default is false.
  final bool loop;

  /// Enabling causes closed captions to be shown by default.
  ///
  /// Default is true.
  final bool enableCaption;

  final bool enableDanmuku;

  /// Specifies the default language that the player will use to display captions. Set the parameter's value to an [ISO 639-1 two-letter language code](http://www.loc.gov/standards/iso639-2/php/code_list.php).
  ///
  /// Default is `en`.
  final String captionLanguage;

  /// Forces High Definition video quality when possible
  ///
  /// Default is false.
  final bool forceHD;

  /// Specifies the default starting point of the video in seconds
  ///
  /// Default is 0.
  final int startAt;

  /// Specifies the default end point of the video in seconds
  final int? endAt;

  /// Set to `true` to enable Flutter's new Hybrid Composition. The default value is `true`.
  /// Hybrid Composition is supported starting with Flutter v1.20+.
  ///
  /// **NOTE**: It is recommended to use Hybrid Composition only on Android 10+ for a release app,
  /// as it can cause framerate drops on animations in Android 9 and lower (see [Hybrid-Composition#performance](https://github.com/flutter/flutter/wiki/Hybrid-Composition#performance)).
  final bool useHybridComposition;

  /// Defines whether to show or hide the fullscreen button in the live player.
  ///
  /// Default is true.
  final bool showLiveFullscreenButton;

  /// Creates [BilibiliPlayerFlags].
  const BilibiliPlayerFlags({
    this.hideControls = false,
    this.controlsVisibleAtStart = false,
    this.autoPlay = true,
    this.mute = false,
    this.isLive = false,
    this.hideThumbnail = false,
    this.enableDanmuku = false,
    this.disableDragSeek = false,
    this.enableCaption = true,
    this.captionLanguage = 'en',
    this.loop = false,
    this.forceHD = false,
    this.startAt = 0,
    this.endAt,
    this.useHybridComposition = true,
    this.showLiveFullscreenButton = true,
  });

  /// Copies new values assigned to the [YoutubePlayerFlags].
  BilibiliPlayerFlags copyWith({
    bool? hideControls,
    bool? autoPlay,
    bool? mute,
    bool? showVideoProgressIndicator,
    bool? isLive,
    bool? hideThumbnail,
    bool? disableDragSeek,
    bool? loop,
    bool? enableCaption,
    bool? enableDanmuku,
    bool? forceHD,
    String? captionLanguage,
    int? startAt,
    int? endAt,
    bool? controlsVisibleAtStart,
    bool? useHybridComposition,
    bool? showLiveFullscreenButton,
  }) {
    return BilibiliPlayerFlags(
      autoPlay: autoPlay ?? this.autoPlay,
      captionLanguage: captionLanguage ?? this.captionLanguage,
      disableDragSeek: disableDragSeek ?? this.disableDragSeek,
      enableCaption: enableCaption ?? this.enableCaption,
      enableDanmuku: enableDanmuku ?? this.enableDanmuku,
      hideControls: hideControls ?? this.hideControls,
      hideThumbnail: hideThumbnail ?? this.hideThumbnail,
      isLive: isLive ?? this.isLive,
      loop: loop ?? this.loop,
      mute: mute ?? this.mute,
      forceHD: forceHD ?? this.forceHD,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      controlsVisibleAtStart:
          controlsVisibleAtStart ?? this.controlsVisibleAtStart,
      useHybridComposition: useHybridComposition ?? this.useHybridComposition,
      showLiveFullscreenButton:
          showLiveFullscreenButton ?? this.showLiveFullscreenButton,
    );
  }
}

class InheritedBilibiliPlayer extends InheritedWidget {
  /// Creates [InheritedYoutubePlayer]
  const InheritedBilibiliPlayer({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  /// A [YoutubePlayerController] which controls the player.
  final BilibiliPlayerController controller;

  @override
  bool updateShouldNotify(InheritedBilibiliPlayer oldPlayer) =>
      oldPlayer.controller.hashCode != controller.hashCode;
}

class BilibiliPlayerController extends ValueNotifier<BilibiliPlayerValue> {
  final String initialVideoId;

  final BilibiliPlayerFlags flags;

  BilibiliPlayerController({
    required this.initialVideoId,
    this.flags = const BilibiliPlayerFlags(),
  }) : super(BilibiliPlayerValue());

  static BilibiliPlayerController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedBilibiliPlayer>()
        ?.controller;
  }

  BilibiliMetaData get metadata => value.metaData;

  void updateValue(BilibiliPlayerValue newValue) {
    value = newValue;
  }

  _callMethod(String methodString) {
    if (value.isReady) {
      value.webViewController?.evaluateJavascript(source: methodString);
    } else {
      print('The controller is not ready for method calls.');
    }
  }

  void mute() => _callMethod('player.setMuted(true)');

  void unMute() => _callMethod('player.setMuted(false)');

  void seekTo(Duration position) {
    _callMethod('seekTo(${position.inSeconds.toDouble()});');
    play();
    updateValue(value.copyWith(position: position));
  }

  void setPlaybackRate(double rate) {
    _callMethod('player.setPlaybackRate($rate);');
  }

  void play() {
    _callMethod('play();');
  }

  void pause() {
    _callMethod('pause();');
  }

  void _updateValues(String id) {
    if (id.length != 11) {
      updateValue(
        value.copyWith(
          errorCode: 1,
        ),
      );
      return;
    }
    updateValue(
      value.copyWith(errorCode: 0, hasPlayed: false),
    );
  }

  void load(String videoId, {int startAt = 0, int? endAt}) {
    var loadParams = 'videoId:"$videoId",startSeconds:$startAt';
    if (endAt != null && endAt > startAt) {
      loadParams += ',endSeconds:$endAt';
    }
    _updateValues(videoId);
    if (value.errorCode == 1) {
      pause();
    } else {
      _callMethod('loadById({$loadParams})');
    }
  }

  void dispose() {}

  void reset() => updateValue(
        value.copyWith(
          isReady: false,
          isFullScreen: false,
          isControlsVisible: false,
          playerState: PlayerState.unknown,
          hasPlayed: false,
          position: Duration.zero,
          buffered: 0.0,
          errorCode: 0,
          isLoaded: false,
          isPlaying: false,
          isDragging: false,
          metaData: const BilibiliMetaData(),
        ),
      );
}
