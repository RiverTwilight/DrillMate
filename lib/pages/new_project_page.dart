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
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';

// Here is the form page to create a project. Here is the project model.
// Please generate the form in Column widget based on this.
class NewProjectPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewProjectPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends ConsumerState<NewProjectPage> {
  bool _isProcessing = false;
  String? _errorText;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text("新建项目"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          bottom: TabBar(
            tabs: [
              Tab(text: "创建项目"),
              Tab(text: "加入项目"),
            ],
          ),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
            child: Flexible(
              child: Column(children: []),
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(hintText: "项目序列号"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(Icons.arrow_forward),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code),
                              SizedBox(
                                width: 12,
                              ),
                              Text("扫描二维码")
                            ]),
                      ),
                    ]),
              )),
        ]),
      ),
    );
  }
}
