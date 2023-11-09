import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/transcription.page.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:hgeology_app/utils/speech_recognizer.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/custom_bottomsheet.dart';
import 'package:hgeology_app/widget/custom_dropdown_button.dart';
import 'package:hgeology_app/widget/settings_section.dart';
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/widget/bookmark_list.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:hgeology_app/gen/strings.g.dart';

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

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

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
      // return Scaffold(
      //     body: Center(
      //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //     Text("Can not find the media file. You can re-import it."),
      //     ElevatedButton(
      //       onPressed: () {
      //         videoManager.deleteVideo(_video!.id);
      //         bookmarkManager.removeBookmarkByMedia(_video!.id);
      //         Navigator.pop(context);
      //       },
      //       child: Text(t.general.deleteStr),
      //     )
      //   ]),
      // ));
    }

    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: width < 600 ? null : Text(_video!.title),
          actions: width < 600
              ? <Widget>[
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
          return Column(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                color: Theme.of(context).colorScheme.primary,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            "川西北油气勘探项目",
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          textColor: Colors.white,
                          leading: const Icon(
                            Icons.date_range,
                            color: Colors.white,
                          ),
                          title: Text(
                            "2023/01/02 12:44:14",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(children: [
                  CardBase(
                    child: InkWell(
                      child: Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            "项目成员",
                          ),
                          leading: const Icon(
                            Icons.group,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 12,
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  CardBase(
                    child: InkWell(
                      child: Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            "综合地图",
                          ),
                          leading: const Icon(
                            Icons.map,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 12,
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  CardBase(
                    child: InkWell(
                      child: Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            "项目进度与工点列表",
                          ),
                          leading: const Icon(
                            Icons.group,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 12,
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  CardBase(
                      child: InkWell(
                          child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "负责单位",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "中建三局",
                                style: TextStyle(fontSize: 16),
                              ),
                            ]),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "项目编号",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "234523XG324",
                                style: TextStyle(fontSize: 16),
                              ),
                            ]),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "工程类别",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "地铁勘查类",
                                style: TextStyle(fontSize: 16),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ))),
                ]),
              )
            ],
          );
        }),
      ),
    ]);
  }
}
