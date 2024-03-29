import 'dart:async';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/transcription.page.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:hgeology_app/utils/speech_recognizer.dart';
import 'package:hgeology_app/widget/custom_bottomsheet.dart';
import 'package:hgeology_app/widget/custom_dropdown_button.dart';
import 'package:hgeology_app/widget/settings_section.dart';
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/widget/bookmark_list.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hgeology_app/utils/srt_converter.dart';
import 'package:hgeology_app/widget/bilibili_player_flutter/player/bilibili_player.dart';
import 'package:hgeology_app/provider/settings_provider.dart';
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
    final settings = ref.watch(settingsProvider);

    return CustomBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TipCard(
            text: '${t.mediaDetailPage.options.mediaSource}${widget.mediaUrl}',
            variant: 'info',
          ),
          const SizedBox(height: 16.0),
          SwitchListTile(
            title: Text(t.mediaDetailPage.options.autoRestore),
            value: settings.autoSeek,
            inactiveTrackColor: Colors.black26,
            onChanged: (bool value) {
              ref.read(settingsProvider.notifier).setAutoSeek(value);
            },
          ),
          const SizedBox(height: 16.0),
          SwitchListTile(
            title: Text(t.mediaDetailPage.options.danmuku),
            value: settings.danmuku,
            inactiveTrackColor: Colors.black26,
            onChanged: (bool value) {
              ref.read(settingsProvider.notifier).setDanmuku(value);
            },
          ),
          const SizedBox(height: 16.0),
          Text(
            '${t.mediaDetailPage.options.speed}${_speed.toStringAsFixed(1)}x',
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

double secondsToDouble(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return minutes + remainingSeconds / 100;
}

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String videoId;

  const ProjectDetailPage({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  late MediaController _mediaController;

  Video? _video;
  Bookmark? _currentBookmark;
  bool _fullscreen = false;
  bool _isCapturing = false;
  bool _isLoop = false;
  bool _isAutoplay = false;
  bool _isTranscribing = false;
  int _captureStartAt = 0;
  int _currentPositionInSeconds = 0;
  Timer? _timer;
  int _currentBookmarkIndex = 0;

  final FloatingActionButtonLocation fabLocation =
      FloatingActionButtonLocation.endDocked;
  final NotchedShape? shape = const CircularNotchedRectangle();
  late ScrollController _controller;
  bool _isVisible = true;
  late MediaType _mediaType;
  double _playbackRate = 1.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = ScrollController();
      _controller.addListener(_listen);

      initMedia(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    _mediaController.pause();
    _mediaController.dispose();

    _stopAutoPlay();

    _controller.removeListener(_listen);
    _controller.dispose();
    super.dispose();
  }

  FloatingActionButtonLocation get _fabLocation => _isVisible
      ? FloatingActionButtonLocation.endContained
      : FloatingActionButtonLocation.endFloat;

  void _listen() {
    final ScrollDirection direction = _controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      _show();
    } else if (direction == ScrollDirection.reverse) {
      _hide();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _playSingleMemo(Bookmark memo) {
    _currentBookmark = memo;
    _mediaController.seekTo(Duration(seconds: memo.startAt));
    _mediaController.play();
  }

  void _stopAutoPlay() {
    setState(() {
      _isAutoplay = false;
    });
    _timer?.cancel();
  }

  void _playAllMemos() {
    final bookmarkManager = ref.read(bookmarkProvider);

    final bookmarks = bookmarkManager.bookmarks
        .where((element) => element.videoId == widget.videoId)
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (bookmarks.isEmpty) {
      return;
    }

    _currentBookmarkIndex = 0;
    _playSingleMemo(bookmarks[_currentBookmarkIndex]);

    _timer?.cancel();

    setState(() {
      _isAutoplay = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isAutoplay) {
        _timer?.cancel();
        return;
      }

      if (_currentPositionInSeconds >= bookmarks[_currentBookmarkIndex].endAt) {
        if (_currentBookmarkIndex < bookmarks.length - 1) {
          _currentBookmark = bookmarks[_currentBookmarkIndex];
          _currentBookmarkIndex++;
          _playSingleMemo(bookmarks[_currentBookmarkIndex]);
        } else {
          _mediaController.pause();
          _timer?.cancel();
          setState(() {
            _isAutoplay = false;
          });
        }
      }
    });
  }

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  void _mediaControllerListener() {
    if (_isLoop &&
        _mediaController.currentPositionInSeconds >= _currentBookmark!.endAt) {
      _mediaController.seekTo(Duration(seconds: _currentBookmark!.startAt));
    }

    setState(() {
      _currentPositionInSeconds = _mediaController.currentPositionInSeconds;
    });

    if (_mediaController.isPlaying) {
      final videoManager = ref.read(videoProvider);

      final updatedMedia =
          _video!.copy(lastPlayPosition: _currentPositionInSeconds);

      videoManager.updateVideo(updatedMedia);
    }
  }

  void initMedia(BuildContext context) async {
    final videoManager = ref.watch(videoProvider);
    final settings = ref.read(settingsProvider);

    // Update [lastOpenedTime]
    Video initialMedia = videoManager.getVideo(widget.videoId);
    initialMedia = initialMedia.copy(lastOpendedDate: DateTime.now());
    _video = initialMedia;
    videoManager.updateVideo(initialMedia);

    _mediaType = _video!.mediaType;

    _mediaController = MediaController(_video!.mediaType, settings.danmuku);

    try {
      final String loadablePath = await _video!.loadablePath;

      _mediaController.initialize(loadablePath).then((_) {
        _mediaController.seekTo(Duration(seconds: _video!.lastPlayPosition));
        _mediaController.play();
        _mediaController.addListener(_mediaControllerListener);
        setState(() {});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Media missing. Try replace with a new one.'),
        ),
      );
    }
  }

  Widget _buildPlayer(BuildContext context) {
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
            : _fullscreen
                ? _mediaController.aspectRatio
                : 1.0,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: Colors.black,
              ),
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _mediaController.activeController.value.size?.width ?? 0,
                height:
                    _mediaController.activeController.value.size?.height ?? 0,
                child: VideoPlayer(_mediaController.activeController),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(_video!.mediaIcon), Text(_video!.title)],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> transcribeAndUpdateVideo(String sourceUrl,
      String selectedLanguage, VideoNotifer videoManager) async {
    try {
      setState(() {
        _isTranscribing = true;
      });

      final stt =
          await transcribeAudio(sourceUrl, languageCode: selectedLanguage);
      final updatedMedia = _video!.copy(subtitles: stt);

      await videoManager.updateVideo(updatedMedia);

      setState(() {
        _isTranscribing = false;
        _video = updatedMedia;
      });
    } catch (error) {
      setState(() {
        _isTranscribing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBookmark(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: BookmarkList(
          currentPositionInSeconds: _currentPositionInSeconds,
          videoId: widget.videoId,
          onWillPop: () {
            _mediaController.pause();
          },
          isAutoplay: _isAutoplay,
          handlePlayAll: _playAllMemos,
          handleCancelPlayAll: _stopAutoPlay,
          onTap: _playSingleMemo,
        ),
      ),
    );
  }

  void _showLanguageSelection(BuildContext context) {
    final videoManager = ref.read(videoProvider);

    _mediaController.pause();
    final languages = {
      'en-US': t.langugaePage.localizedLanguageName.enUS,
      'en-UK': t.langugaePage.localizedLanguageName.enGB,
      'fr': t.langugaePage.localizedLanguageName.fr,
      'zh-CN': t.langugaePage.localizedLanguageName.zhCN,
      'zh-HK': t.langugaePage.localizedLanguageName.zhHK,
      'ja': t.langugaePage.localizedLanguageName.jp,
      'ko': t.langugaePage.localizedLanguageName.ko,
    };

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          String selectedLanguage = "en-US";

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return CustomBottomSheet(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingsEntry(
                  label: t.general.language,
                  child: CustomDropdownButton(
                    value: selectedLanguage,
                    items: languages.entries.map((language) {
                      return DropdownMenuItem(
                        value: language.key,
                        child: Text(language.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                  ),
                ),
                (_mediaType == MediaType.localAudio ||
                        _mediaType == MediaType.localVideo)
                    ? Column(children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                            foregroundColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onPrimary,
                          ),
                          onPressed: _isTranscribing
                              ? null
                              : () async {
                                  transcribeAndUpdateVideo(
                                      await _video!.loadablePath,
                                      selectedLanguage,
                                      videoManager);

                                  Navigator.of(context).pop();
                                },
                          child: Text(_isTranscribing
                              ? t.mediaDetailPage.transcript.transcribingStr
                              : t.mediaDetailPage.transcript.startBtn),
                        ),
                        TipCard(
                          text: t.mediaDetailPage.transcript.tip,
                          variant: "info",
                        )
                      ])
                    : SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                              t.mediaDetailPage.transcript.localLimitationHint),
                        ),
                      ),
              ],
            ));
          });
        });
  }

  void _transcribe(BuildContext context) {
    if (_video!.subtitles.isEmpty) {
      _showLanguageSelection(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TranscriptionPage(
            subtitles: _video!.subtitles,
          ),
        ),
      );
    }
  }

  void _delete(BuildContext context) {
    final videoManager = ref.read(videoProvider);
    final bookmarkManager = ref.read(bookmarkProvider);

    videoManager.deleteVideo(_video!.id);
    bookmarkManager.removeBookmarkByMedia(_video!.id);
    Navigator.pop(context);
  }

  void _rename(BuildContext context) {
    final videoManager = ref.read(videoProvider);

    _mediaController.pause();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        TextEditingController renameController = TextEditingController();
        renameController.text = _video!.title;

        return CustomBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: renameController,
                decoration: InputDecoration(
                  labelText: t.mediaDetailPage.rename.label,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final updatedMedia =
                      _video!.copy(title: renameController.text);

                  videoManager.updateVideo(updatedMedia);
                  Navigator.pop(context);
                },
                child: Text(t.general.rename),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  void _share(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coming Soon...'),
      ),
    );

    // final bookmarkManager = ref.watch(bookmarkProvider);

    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (BuildContext context) {
    //     return CustomBottomSheet(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           ListTile(
    //               onTap: () {
    //                 if (AuthProvider().loggedIn) {
    //                   StoreProvider().uploadCase(
    //                     AuthProvider().user!.id,
    //                     _video!.title,
    //                     description: "No description",
    //                     sourceUrl: _video!.sourceUrl,
    //                     bookmarks:
    //                         bookmarkManager.getAllBookmarkByMedia(_video!.id),
    //                   );
    //                 }
    //               },
    //               title: Text(t.mediaDetailPage.share.publishToStore.title),
    //               trailing: const Icon(Icons.cloud)),
    //           ListTile(
    //             title: Text(t.mediaDetailPage.share.export.title),
    //             onTap: () {
    //               Navigator.pop(context);
    //             },
    //             trailing: const Icon(Icons.download_rounded),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  Widget _buildTranscribingIndicator(BuildContext buildContext) {
    if (!_isTranscribing) return Container();

    return (InkWell(
      onTap: () {
        _showLanguageSelection(context);
      },
      child: const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 4,
        ),
      ),
    ));
  }

  Widget _buildFullscreenSwitch(BuildContext buildContext) {
    return (IconButton(
      icon: _fullscreen
          ? const Icon(Icons.fullscreen_exit_rounded)
          : const Icon(Icons.fullscreen),
      onPressed: () {
        setState(() {
          _fullscreen = !_fullscreen;
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final videoManager = ref.watch(videoProvider);
    final bookmarkManager = ref.watch(bookmarkProvider);
    final width = MediaQuery.of(context).size.width;

    if (_video == null) {
      return Scaffold(
          body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Can not find the media file. You can re-import it."),
          ElevatedButton(
            onPressed: () {
              videoManager.deleteVideo(_video!.id);
              bookmarkManager.removeBookmarkByMedia(_video!.id);
              Navigator.pop(context);
            },
            child: Text(t.general.deleteStr),
          )
        ]),
      ));
    }

    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: width < 600 ? null : Text(_video!.title),
          actions: width < 600
              ? <Widget>[
                  _buildTranscribingIndicator(context),
                  _buildFullscreenSwitch(context),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded),
                    onSelected: (value) {
                      switch (value) {
                        case 'Rename':
                          _rename(context);
                          break;
                        case 'Delete':
                          _delete(context);
                          break;
                        case "Transcribe":
                          _transcribe(context);
                          break;
                        case "Share":
                          _share(context);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Rename',
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(t.general.rename),
                          leading: const Icon(Icons.edit_rounded),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Transcribe',
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title:
                              Text(t.mediaDetailPage.appBarActions.transcribe),
                          leading: const Icon(Icons.mic_rounded),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Share',
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(t.mediaDetailPage.share.title),
                          leading: const Icon(Icons.share),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Delete',
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(
                            t.general.deleteStr,
                            style: const TextStyle(color: Colors.red),
                          ),
                          leading: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              : <Widget>[
                  _buildTranscribingIndicator(context),
                  _buildFullscreenSwitch(context),
                  TextButton.icon(
                    onPressed: () {
                      _rename(context);
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(t.general.rename),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _transcribe(context);
                    },
                    icon: const Icon(Icons.mic_rounded),
                    label: Text(t.mediaDetailPage.appBarActions.transcribe),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded),
                    onSelected: (value) {
                      switch (value) {
                        case 'Delete':
                          _delete(context);
                          break;
                        case "Share":
                          _share(context);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Replace',
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(t.mediaDetailPage.appBarActions.replace),
                          leading: const Icon(Icons.switch_video_rounded),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Delete',
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(
                            t.general.deleteStr,
                            style: const TextStyle(color: Colors.red),
                          ),
                          leading: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              // Larger screen
              return Scaffold(
                body: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            kBottomNavigationBarHeight -
                            kToolbarHeight -
                            80,
                        child: _buildPlayer(context),
                      ),
                    ),
                    if (!_fullscreen)
                      SizedBox(
                        width: 320,
                        child: _buildBookmark(context),
                      )
                  ],
                ),
              );
            } else {
              // Smaller screen
              return Column(
                children: <Widget>[
                  if (_fullscreen)
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 230,
                      child: _buildPlayer(context),
                    ),
                  if (!_fullscreen) ...[
                    _buildPlayer(context),
                    const SizedBox(
                      height: 4,
                    ),
                    _buildBookmark(context)
                  ],
                ],
              );
            }
          },
        ),
        floatingActionButtonLocation: _fabLocation,
        floatingActionButton: FloatingActionButton.extended(
          elevation: _isVisible ? 0.0 : null,
          icon: Icon(_isCapturing ? Icons.stop : Icons.bookmark_add),
          label: Text(_isCapturing
              ? convertSecondsToTimestamp(_currentPositionInSeconds)
              : t.mediaDetailPage.startCaptureBtn),
          onPressed: () {
            if (bookmarkManager.bookmarks.length > maxMemoCountForFreeAccount &&
                !DataProvider().isPlus) {
              print("Limitation Reached");

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(t.mediaDetailPage.limitationReachedHint)));
            } else {
              // Continue normal logic
              if (_isCapturing) {
                // When currently capturing, stop it
                int captureEndAt;

                _mediaController.pause();
                setState(() {
                  captureEndAt = _mediaController.currentPositionInSeconds;

                  String defaultTitle =
                      'Memo  ${bookmarkManager.bookmarks.length}';

                  if (_video!.subtitles.isNotEmpty) {
                    defaultTitle = getTextForTimeInterval(
                      _captureStartAt.toDouble(),
                      captureEndAt.toDouble(),
                      _video!.subtitles,
                    );
                  }

                  TextEditingController nameController =
                      TextEditingController();

                  nameController.text = defaultTitle;

                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(t.dialog.renameBookmark.title),
                        content: TextField(
                          controller: nameController,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              String newId = const Uuid().v4();

                              bookmarkManager.addBookmark(
                                id: newId,
                                title: nameController.text,
                                note: '',
                                videoId: _video!.id,
                                startAt: _captureStartAt,
                                endAt: captureEndAt,
                                tags: [_video!.mediaType.humanName],
                              );

                              _isCapturing = false;

                              Navigator.of(context).pop();

                              _mediaController.play();
                            },
                            child: Text(t.general.confirm),
                          ),
                        ],
                      );
                    },
                  );
                });
              } else {
                setState(() {
                  _captureStartAt = _mediaController.currentPositionInSeconds;
                  _isLoop = false;
                  _isCapturing = true;
                });
              }
            }
          },
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: BottomAppBar(
                // shape: shape,
                // height: kBottomNavigationBarHeight + 100,
                child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.onSurface),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        tooltip: t.mediaDetailPage.loopModeSwitch,
                        isSelected: _isLoop,
                        selectedIcon: Icon(Icons.loop,
                            color: Theme.of(context).colorScheme.primary),
                        icon: const Icon(Icons.loop),
                        onPressed: () {
                          setState(() {
                            _isLoop = !_isLoop;
                          });
                        },
                      ),
                      if (width > 600) ...[
                        Text(t.mediaDetailPage.loopBtn),
                        const SizedBox(width: 12),
                      ],
                      if (centerLocations.contains(fabLocation)) const Spacer(),
                      IconButton(
                        tooltip: t.mediaDetailPage.optionsBtn,
                        icon: const Icon(Icons.tune_rounded),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SpeedControlBottomSheet(
                                initialSpeed: _playbackRate,
                                mediaUrl: _video!.sourceUrl,
                                onSpeedChanged: (double value) {
                                  _playbackRate = value;
                                  _mediaController
                                      .setPlaybackSpeed(_playbackRate);
                                },
                              );
                            },
                          );
                        },
                      ),
                      if (width > 600) ...[
                        Text(t.mediaDetailPage.optionsBtn),
                        const SizedBox(width: 12),
                      ],
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _mediaController.isPlaying
                                ? _mediaController.pause()
                                : _mediaController.play();
                          });
                        },
                        icon: Icon(
                          _mediaController.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      if (width > 600) ...[
                        Text(_mediaController.isPlaying
                            ? t.general.pause
                            : t.general.play),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (width > 600 && !_fullscreen)
              const SizedBox(
                width: 320,
              ),
          ],
        ),
      ),
      // if (_showProgress)
      //   Positioned(
      //     left: 0,
      //     right: width > 600 ? 320 : 0,
      //     bottom: kBottomNavigationBarHeight +
      //         MediaQuery.of(context).padding.bottom +
      //         40,
      //     child: SizedBox(
      //       child: Center(
      //         child: Text(
      //           convertSecondsToTimestamp(_currentPositionInSeconds),
      //           style: Theme.of(context).textTheme.bodySmall,
      //         ),
      //       ),
      //     ),
      //   ),
      if (_mediaController.totalDurationInSeconds > 1)
        Positioned(
          left: 0,
          right: (width > 600 && !_fullscreen) ? 320 : 0,
          bottom: kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom -
              0.5,
          child: Material(
            type: MaterialType.transparency,
            child: Slider(
              value: min(_currentPositionInSeconds.toDouble(),
                  _mediaController.totalDurationInSeconds.toDouble()),
              min: 0,
              max: _mediaController.totalDurationInSeconds.toDouble(),
              // divisions: _mediaController.totalDurationInSeconds.toDouble(),
              // label: convertSecondsToTimestamp(_currentPositionInSeconds),
              onChanged: (double value) {
                setState(() {
                  _currentPositionInSeconds = value.toInt();
                  _mediaController
                      .seekTo(Duration(seconds: _currentPositionInSeconds));
                });
              },
            ),
          ),
        )
    ]);
  }
}

extension on MediaType {
  String get humanName {
    switch (this) {
      case MediaType.bilibili:
        return "Bilibili";
      case MediaType.youtube:
        return "YouTube";
      case MediaType.localAudio:
        return "Audio";
      case MediaType.localVideo:
        return "Video";
      case MediaType.remoteAudio:
        return "Audio";
      case MediaType.remoteVideo:
        return "Video";
    }
  }
}
