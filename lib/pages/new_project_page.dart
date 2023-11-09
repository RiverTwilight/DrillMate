import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/store/store_page.dart';
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

class NewProjectPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewProjectPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends ConsumerState<NewProjectPage> {
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
      // String newId = const Uuid().v4();

      // Video media = Video(
      //   id: newId,
      //   title: name ?? p.basename(path),
      //   sourceUrl: newPath,
      //   thumbnailUrl: '',
      //   createDate: DateTime.now(),
      //   lastOpendedDate: DateTime.now(),
      // );

      // await videoManager.addVideo(media);

      // handleFinishImport();
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
              onPressed: () {},
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
                    children: [],
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
