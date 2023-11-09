import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/reviewLog_provider.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:hgeology_app/theme.dart';
import 'package:hgeology_app/utils/priviliage_checker.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/custom_bottomsheet.dart';
import 'package:hgeology_app/widget/custom_constrained_box.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:hgeology_app/widget/bilibili_player_flutter/player/bilibili_player.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class SpeedControlBottomSheet extends ConsumerStatefulWidget {
  final double initialSpeed;
  final String mediaUrl;
  final ValueChanged<double> onSpeedChanged;

  const SpeedControlBottomSheet({
    super.key,
    required this.initialSpeed,
    required this.mediaUrl,
    required this.onSpeedChanged,
  });

  @override
  _SpeedControlBottomSheetState createState() =>
      _SpeedControlBottomSheetState();
}

class _SpeedControlBottomSheetState
    extends ConsumerState<SpeedControlBottomSheet> {
  late double _speed;

  @override
  void initState() {
    super.initState();
    _speed = widget.initialSpeed;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Speed: ${_speed.toStringAsFixed(1)}x',
            style: const TextStyle(fontSize: 16.0),
          ),
          Slider(
            value: _speed,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: (double value) {
              setState(() {
                _speed = value;
              });
              widget.onSpeedChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

/// * **When press 'Next' or 'previous'**: call [_handleBookmarkChange] -> [_initializePlayer]
class _ReviewPageState extends ConsumerState<ReviewPage> {
  late int dailyReviewCount = 5;
  late List<Bookmark> selectedBookmarks = [];
  int currentIndex = 0;
  late Bookmark _currentBookmark;

  double _playbackRate = 1.0;
  bool _isPlaying = false;

  Video? _video;
  MediaType? _mediaType;
  late MediaController _mediaController;

  bool _isMediaControllerInitialized = false;

  void _pause() {
    if (_isMediaControllerInitialized) {
      _mediaController.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Widget _buildPlayer(BuildContext context) {
    if (_video == null ||
        _mediaType == null ||
        !_isMediaControllerInitialized) {
      return Container();
    }

    if (_mediaType == MediaType.youtube) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          onReady: () {
            _mediaController
                .seekTo(Duration(seconds: _video!.lastPlayPosition));
          },
          controller: _mediaController.activeController,
        ),
        builder: (context, player) {
          return player;
        },
      );
    } else if (_mediaType == MediaType.bilibili) {
      return BilibiliPlayerBuilder(
        player: BilibiliPlayer(
          onReady: () {
            _mediaController
                .seekTo(Duration(seconds: _video!.lastPlayPosition));
          },
          controller: _mediaController.activeController,
        ),
        builder: (context, player) {
          return player;
        },
      );
    } else if (_mediaType == MediaType.localVideo) {
      return AspectRatio(
        aspectRatio: _mediaController.aspectRatio > 1.0
            ? _mediaController.aspectRatio
            : 1.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_mediaController.activeController),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _playBookmark(Bookmark bookmark) {
    if (_video != null && _isMediaControllerInitialized) {
      _mediaController.pause();
    }

    _mediaController.seekTo(Duration(seconds: bookmark.startAt));
    _mediaController.play();
    setState(() {
      _currentBookmark = bookmark;
      _isPlaying = true;
    });
  }

  void _initializePlayer(Video targetMedia,
      {int startAt = 0, bool autoPlay = false}) async {
    if (targetMedia != _video) {
      setState(() {
        _video = targetMedia;
        _mediaType = targetMedia.mediaType;
      });

      _mediaController = MediaController(targetMedia.mediaType, false);

      _mediaType = targetMedia.mediaType;

      final String loadablePath = await targetMedia.loadablePath;

      _mediaController.initialize(loadablePath).then((_) {
        _mediaController.seekTo(Duration(seconds: startAt));
        if (autoPlay) {
          _mediaController.play();
        }
        _mediaController.addListener(_mediaControllerListener);
        _isMediaControllerInitialized = true;
      });
    }
  }

  void _handleBookmarkChange(String mediaId) {
    final videoManager = ref.read(videoProvider);

    final targetMedia = videoManager.getVideo(mediaId);

    _initializePlayer(
      targetMedia,
      startAt: _currentBookmark.startAt,
    );
  }

  void _mediaControllerListener() {
    if (_mediaController.currentPositionInSeconds >= _currentBookmark.endAt) {
      _mediaController.seekTo(Duration(seconds: _currentBookmark.startAt));
    }

    // Force the media player sync with the user intention.
    // Otherwise the media will auto play when opening the page.
    if (_mediaController.isPlaying != _isPlaying &&
        _mediaType != MediaType.localVideo) {
      if (_isPlaying) {
        _mediaController.play();
      } else {
        _mediaController.pause();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookmarks = ref.read(bookmarkProvider).bookmarks;

      if (bookmarks.isEmpty) return;

      selectedBookmarks = bookmarks..shuffle();
      selectedBookmarks = selectedBookmarks.take(dailyReviewCount).toList();

      setState(() {
        selectedBookmarks = selectedBookmarks;
        _currentBookmark = selectedBookmarks[currentIndex];
        dailyReviewCount = min(dailyReviewCount, bookmarks.length);
      });

      _handleBookmarkChange(_currentBookmark.videoId);
    });
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: const LeadingBackButton(),
      title: Text(t.reviewTab.title),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SpeedControlBottomSheet(
                  initialSpeed: _playbackRate,
                  mediaUrl: _video!.sourceUrl,
                  onSpeedChanged: (double value) {
                    _playbackRate = value;
                    _mediaController.setPlaybackSpeed(_playbackRate);
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.tune_rounded),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedBookmarks.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: Text(t.reviewTab.emptyHint),
        ),
      );
    }

    final userDataManager = ref.read(userDataProvider);

    if (!hasPrivilage(FeatureFlags.dailyReview, userDataManager.isPlus)) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: Text(t.general.noEligibilityHint),
        ),
      );
    }

    final fatherMedia =
        ref.read(videoProvider).getVideo(_currentBookmark.videoId);
    final reviewLogsManager = ref.watch(reviewLogsProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: CustomConstrainedBox(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              child: SizedBox(
                width: double.infinity,
                height: width > 600 ? 260 : 200,
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius:
                            Theme.of(context).inputDecorationTheme.borderRadius,
                        child: _buildPlayer(context),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius:
                            Theme.of(context).inputDecorationTheme.borderRadius,
                        child: InkWell(
                          onTap: () {
                            if (_isPlaying) {
                              _pause();
                            } else {
                              _playBookmark(_currentBookmark);
                            }
                          },
                          child: Container(
                            color:
                                Colors.black.withOpacity(_isPlaying ? 0 : 0.8),
                            child: Center(
                              child: _isPlaying
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          const Icon(Icons.play_arrow_rounded,
                                              color: Colors.white),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            t.reviewTab.playAnwser,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              leading: const Icon(Icons.book),
              title: Text(_currentBookmark.title),
            ),
            ListTile(
              leading: const Icon(
                Icons.video_collection,
              ),
              dense: true,
              title: Text(fatherMedia.title),
            ),
            if (_currentBookmark.note.isNotEmpty)
              CardBase(
                child: SizedBox(
                  height: 100,
                  child: Expanded(child: Markdown(data: _currentBookmark.note)),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0
                      ? () {
                          _pause();
                          setState(() {
                            currentIndex--;
                            _currentBookmark = selectedBookmarks[currentIndex];
                          });

                          _handleBookmarkChange(
                              selectedBookmarks[currentIndex].videoId);
                        }
                      : null, // Disable the button if at the beginning
                  child: Text(t.general.previous),
                ),
                Text('${currentIndex + 1}/$dailyReviewCount'), // Progress text
                ElevatedButton(
                  onPressed: currentIndex < dailyReviewCount - 1
                      ? () {
                          _pause();
                          setState(() {
                            currentIndex++;
                            _currentBookmark = selectedBookmarks[currentIndex];
                          });

                          _handleBookmarkChange(
                              selectedBookmarks[currentIndex].videoId);

                          reviewLogsManager.addLog(
                            mediaId: fatherMedia.id,
                            bookmarkId: _currentBookmark.id,
                            recordUrl: "",
                          );
                        }
                      : null, // Disable the button if at the end
                  child: Row(children: [
                    Text(t.general.next),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.arrow_forward)
                  ]),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    if (_isMediaControllerInitialized) {
      _mediaController.dispose();
    }
    super.dispose();
  }
}
