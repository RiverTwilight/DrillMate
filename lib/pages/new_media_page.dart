import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/plan_page.dart';
import 'package:hgeology_app/pages/store/store_page.dart';
import 'package:hgeology_app/provider/collection_provider.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hgeology_app/provider/settings_provider.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:hgeology_app/utils/link_generator.dart';
import 'package:hgeology_app/utils/url_checker.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/custom_bottomsheet.dart';
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hgeology_app/provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:http/http.dart' as http;

Future<String> copyFileToAppDirectory(String filePath) async {
  final fileName = p.basename(filePath);
  final directory = await getApplicationDocumentsDirectory();
  final newPath = p.join(directory.path, fileName);

  final File file = File(filePath);
  await file.copy(newPath);

  return newPath;
}

class NewMediaPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewMediaPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewMediaPage> createState() => _NewMediaPageState();
}

class _NewMediaPageState extends ConsumerState<NewMediaPage> {
  final TextEditingController _youtubeUrlController = TextEditingController();
  final TextEditingController _bilibiliUrlController = TextEditingController();
  bool _isProcessing = false;
  String? _errorText;
  bool _autoFetchTitle = true;

  @override
  void initState() {
    super.initState();

    final settings = ref.read(settingsProvider);

    _autoFetchTitle = settings.autoFetchYoutubeTitle;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      handleSharePayload();
    });
  }

  /// Handle share intent from external
  ///
  /// ## Example
  /// * From bilibili: https://b23.tv/fcBpTGP or https://b23.tv/ep403070
  /// * From youtube: https://youtu.be/EZTdWzsfLEU or https://www.youtube.com/watch?v=bVK7t9uGoLU
  void handleSharePayload() async {
    final payload = widget.sharePayload;

    if (payload != null) {
      if (payload.content!.length > 5) {
        final content = payload.content!;

        switch (checkResource(content)) {
          case MediaType.youtube:
            _youtubeUrlController.text = content;
            _addYoutubeVideo(ref.read(videoProvider));
            break;
          case MediaType.bilibili:
            _bilibiliUrlController.text = content;
            _addBilibiliVideo();
            break;
          default:
            break;
        }
      } else if (payload.attachments != null) {
        widget.sharePayload?.attachments?.forEach((element) async {
          await _addFileToDatabase(element!.path, ref);
        });

        _showSuccessSnackbar();
      }
    }
  }

  void _showSuccessSnackbar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.newMediaPage.finishImport,
          style: const TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: t.general.view,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showErrorSnackbar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.newMediaPage.importError,
          style: const TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void handleFinishImport() async {
    if (context.mounted) {
      _showSuccessSnackbar();
    }
  }

  Future<void> _addFileToDatabase(String path, WidgetRef ref,
      {String? name}) async {
    final videoManager = ref.read(videoProvider);

    try {
      String newId = const Uuid().v4();
      String newPath = await copyFileToAppDirectory(path);

      Video media = Video(
        id: newId,
        title: name ?? p.basename(path),
        sourceUrl: newPath,
        thumbnailUrl: '',
        createDate: DateTime.now(),
        lastOpendedDate: DateTime.now(),
      );

      await videoManager.addVideo(media);

      handleFinishImport();
    } catch (e) {
      _showErrorSnackbar();
    }
  }

  bool get isAvaliable {
    final videos = ref.read(videoProvider).videos;

    return !(videos.length > maxMediaCountForFreeAccount &&
        !DataProvider().isPlus);
  }

  void handleNoPermission() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.newMediaPage.permission.title),
          content: Text(t.newMediaPage.permission.body),
          actions: [
            TextButton(
              child: Text(t.newMediaPage.permission.upgrade),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanPage()),
                );
              },
            ),
            TextButton(
              child: Text(t.general.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> fetchYouTubeVideoDetails(
      String videoId, String apiKey) async {
    final String url =
        'https://www.googleapis.com/youtube/v3/videos?id=$videoId&key=$apiKey&part=snippet';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['items'] != null && jsonResponse['items'].isNotEmpty) {
        return jsonResponse['items'][0]['snippet']['title'];
      }
    } else {
      print(
          'Failed to load video details. HTTP status: ${response.statusCode}');
    }
    return null;
  }

  Future<void> _addYoutubeVideo(VideoNotifer videoManager) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CustomBottomSheet(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      spellCheckConfiguration:
                          const SpellCheckConfiguration.disabled(),
                      controller: _youtubeUrlController,
                      decoration: const InputDecoration(
                        hintText:
                            "https://youtube.com/?v=xxxx, https://youtu.be/xxxx",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _autoFetchTitle,
                              onChanged: (bool? value) {
                                setState(() {
                                  _autoFetchTitle = value ?? true;
                                });

                                ref
                                    .read(settingsProvider.notifier)
                                    .setAutoFetchYoutubeTitle(value ?? true);
                              },
                            ),
                            Text(t.newMediaPage.youtube.fetchTitle),
                          ],
                        ),
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
                          child: Text(t.general.confirm),
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  if (!isAvaliable) {
                                    handleNoPermission();
                                    return;
                                  }

                                  setState(() {
                                    _isProcessing = true;
                                    _errorText = null;
                                  });

                                  String url = _youtubeUrlController.text;
                                  RegExp regExp = RegExp(
                                    r"(?<=watch\?v=|/videos/|embed\/|youtu.be\/|\/v\/|\/e\/|watch\?v%3D|watch\?feature=player_embedded&v=|%2Fvideos%2F|embed%\2F|youtu.be%2F|%2Fv%2F)[^#&?%\n]*",
                                  );

                                  String? videoId =
                                      regExp.firstMatch(url)?.group(0);

                                  if (videoId != null && videoId.isNotEmpty) {
                                    String? videoTitle = _autoFetchTitle
                                        ? await fetchYouTubeVideoDetails(
                                            videoId, youtubeApiKey)
                                        : "YouTube";

                                    String? thumbnailUrl =
                                        "https://i.ytimg.com/vi/$videoId/default.jpg"; // Default thumbnail URL

                                    String newId = const Uuid().v4();
                                    Video video = Video(
                                      id: newId,
                                      title: videoTitle ?? "YouTube video",
                                      thumbnailUrl: thumbnailUrl,
                                      createDate: DateTime.now(),
                                      lastOpendedDate: DateTime.now(),
                                      sourceUrl: url,
                                    );

                                    await videoManager.addVideo(video);

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    Navigator.pop(context);
                                    handleFinishImport();
                                  } else {
                                    setState(() {
                                      _errorText = 'Invalid YouTube URL';
                                      _isProcessing = false;
                                    });
                                  }
                                },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TipCard(
                      text: t.newMediaPage.youtubeHint,
                      variant: "info",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> _addCollection() async {
    final collectionManager = ref.read(collectionProvider);

    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isProcessing = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (_, StateSetter setState) {
            return CustomBottomSheet(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Name",
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Description (Optional)",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        onPressed: () async {
                          final id = const Uuid().v4();
                          await collectionManager.createCollection(
                              id: id,
                              title: nameController.text,
                              description: descriptionController.text);

                          Navigator.pop(context);
                        },
                        child: Text(t.general.confirm),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addLocalVideo(VideoNotifer videoManager) async {
    if (!isAvaliable) {
      handleNoPermission();
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // TODO support multiple files

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null) {
      await _addFileToDatabase(result.files.single.path!, ref,
          name: result.files.single.name);
    }

    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _addFromLocalAudio(VideoNotifer videoManager) async {
    if (!isAvaliable) {
      handleNoPermission();
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["wav", "aac", "mp3", "m4a"],
      allowMultiple: false,
    );
    if (result != null) {
      _addFileToDatabase(result.files.single.path!, ref,
          name: result.files.single.name);
    }
  }

  // Future<void> _addFromGallery(VideoNotifer videoManager) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     String newId = const Uuid().v4();
  //     String newPath = await copyFileToAppDirectory(pickedFile.path);

  //     Video video = Video(
  //       id: newId,
  //       title: p.basename(pickedFile.path),
  //       sourceUrl: newPath,
  //       thumbnailUrl: '',
  //       createDate: DateTime.now(),
  //     );
  //     await videoManager.addVideo(video);
  //     if (context.mounted) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => MediaDetailPage(
  //             videoId: newId,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> _addTedVideo(VideoNotifer videoManager) async {
    final videoManager = ref.read(videoProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
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
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.file_download),
                        Text(t.newMediaPage.tedFile)
                      ]),
                    ),
                  ),
                  onTap: () {
                    _addLocalVideo(videoManager);
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              TextButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse(Links().tedTutorial));
                },
                icon: const Icon(Icons.help),
                label: Text(t.newMediaPage.tedHelpBtn),
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
        );
      },
    );
  }

  void _addWeChatFile() {
    launchUrl(Uri.parse(Links().tedTutorial));
  }

  Future<void> _addBilibiliVideo() async {
    final videoManager = ref.read(videoProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                spellCheckConfiguration:
                    const SpellCheckConfiguration.disabled(),
                controller: _bilibiliUrlController,
                decoration: const InputDecoration(
                  // icon: Icon(Icons.link),
                  // labelText: "Enter Bilibili URL",
                  hintText: "https://bilibili.com/BVxxx, https://b23.tv/xxx",
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.primary,
                  foregroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                ),
                onPressed: () async {
                  if (!isAvaliable) {
                    handleNoPermission();
                    return;
                  }

                  String realUrl = _bilibiliUrlController.text;

                  final RegExp pattern = RegExp(r'https:\/\/b23\.tv\/ep\d+');

                  if (_bilibiliUrlController.text.contains('bilibili.com') ||
                      (_bilibiliUrlController.text.contains('b23.tv') &&
                          !pattern.hasMatch(_bilibiliUrlController.text))) {
                    setState(() {
                      _isProcessing = true;
                    });
                    realUrl = await getRealUrl(_bilibiliUrlController.text);
                    String newId = const Uuid().v4();
                    Video video = Video(
                      id: newId,
                      title: "Bilibili",
                      thumbnailUrl: "sdf",
                      createDate: DateTime.now(),
                      lastOpendedDate: DateTime.now(),
                      sourceUrl: realUrl,
                    );
                    await videoManager.addVideo(video);

                    setState(() {
                      _isProcessing = false;
                    });

                    Navigator.pop(context);

                    handleFinishImport();
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(t.dialog.addBilibiliError.title),
                          content: Text(t.dialog.addBilibiliError.body),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pop(), // Close dialog without adding
                              child: Text(t.general.cancel),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_isProcessing) ...[
                    const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                  Text(t.general.confirm)
                ]),
              ),
              const SizedBox(
                height: 18,
              ),
              TipCard(
                text: t.newMediaPage.bilibiliHint,
                variant: "info",
                handleLearnMore: () {},
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Example
  ///
  /// * SSPAI Podcast: https://v.typlog.com/sspai/8302908826_408734.mp3
  Future<void> _addMediaFromUrl() async {
    final videoManager = ref.read(videoProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autocorrect: false,
                keyboardType: TextInputType.url,
                controller: _bilibiliUrlController,
                decoration: InputDecoration(
                  hintText: t.newMediaPage.source.directUrl,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.primary,
                  foregroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                ),
                onPressed: () async {
                  if (!isAvaliable) {
                    handleNoPermission();
                    return;
                  }

                  String realUrl = _bilibiliUrlController.text;
                  Uri? uri = Uri.tryParse(realUrl);
                  String title = "Url File";

                  // Check if URL is valid
                  if (uri != null && uri.isAbsolute) {
                    // Extract file name from URL
                    List<String> segments = uri.pathSegments;
                    if (segments.isNotEmpty) {
                      title = segments.last;
                    }
                  } else {
                    // Handle invalid URL input
                    // For example, show a dialog to inform the user
                    return;
                  }

                  setState(() {
                    _isProcessing = true;
                  });

                  String newId = const Uuid().v4();
                  Video video = Video(
                    id: newId,
                    title: title, // Use extracted or default title
                    thumbnailUrl: "sdf",
                    createDate: DateTime.now(),
                    lastOpendedDate: DateTime.now(),
                    sourceUrl: realUrl,
                  );
                  await videoManager.addVideo(video);

                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.pop(context);

                  handleFinishImport();
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_isProcessing) ...[
                    const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                  Text(t.general.confirm)
                ]),
              ),
              const SizedBox(
                height: 18,
              ),
              TipCard(
                text: t.newMediaPage.remoteFileHint,
                variant: "info",
                // handleLearnMore: () {},
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, int index, String sourceName,
      Widget icon, VoidCallback onSelcted) {
    return CardBase(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onSelcted,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align items along the center
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 6, bottom: 3, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center vertically in the column
                            children: [
                              icon,
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                sourceName,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.visible,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGroup(BuildContext context,
      {required List<Widget> children}) {
    return ShrinkWrappingViewport(
      offset: ViewportOffset.zero(),
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width > 600) ? 4 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 200 / 120,
          ),
          delegate: SliverChildListDelegate(children),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoManager = ref.watch(videoProvider);

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text(t.newMediaPage.title),
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          bottom: TabBar(
            tabs: [
              Tab(text: t.newMediaPage.customTab),
              Tab(text: t.newMediaPage.onlineTab),
            ],
          ),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
            child: Column(
              children: [
                Flexible(
                  child: _buildMediaGroup(
                    context,
                    children: [
                      _buildCard(
                          context,
                          1,
                          t.newMediaPage.source.youtube,
                          const FaIcon(
                            FontAwesomeIcons.youtube,
                            color: Colors.red,
                          ),
                          () => _addYoutubeVideo(videoManager)),
                      _buildCard(
                          context,
                          2,
                          t.newMediaPage.source.bilibili,
                          const FaIcon(
                            FontAwesomeIcons.bilibili,
                            color: Colors.pink,
                          ),
                          () => _addBilibiliVideo()),
                      _buildCard(
                          context,
                          3,
                          t.newMediaPage.source.ted,
                          FaIcon(
                            FontAwesomeIcons.film,
                            color: Colors.red[700],
                          ),
                          () => _addTedVideo(videoManager)),
                      _buildCard(
                        context,
                        4,
                        t.newMediaPage.source.wechat,
                        const FaIcon(
                          FontAwesomeIcons.weixin,
                          color: Colors.green,
                        ),
                        () => _addWeChatFile(),
                      ),
                      _buildCard(
                        context,
                        5,
                        t.newMediaPage.source.directUrl,
                        const FaIcon(
                          FontAwesomeIcons.link,
                          color: Colors.blue,
                        ),
                        () => _addMediaFromUrl(),
                      ),
                      _buildCard(
                        context,
                        6,
                        t.newMediaPage.source.localVideo,
                        _isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : const Icon(Icons.file_present_rounded),
                        () => _addLocalVideo(videoManager),
                      ),
                      _buildCard(
                        context,
                        7,
                        t.newMediaPage.source.localAudio,
                        const Icon(Icons.audio_file),
                        () => _addFromLocalAudio(videoManager),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CardBase(
                  child: InkWell(
                    child: Align(
                      alignment: Alignment.center,
                      child: ListTile(
                        title: Text(
                          t.newMediaPage.createCollection.title,
                        ),
                        leading: const Icon(
                          Icons.create_new_folder_rounded,
                        ),
                      ),
                    ),
                    onTap: () {
                      _addCollection();
                    },
                  ),
                ),
              ],
            ),
          ),
          const StorePage(),
        ]),
      ),
    );
  }
}
