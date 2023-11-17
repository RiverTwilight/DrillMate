import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/store/store_page.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:file_picker/file_picker.dart';

class ProjectMapPage extends ConsumerStatefulWidget {
  const ProjectMapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProjectMapPage> createState() => _ProjectMapPageState();
}

class _ProjectMapPageState extends ConsumerState<ProjectMapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: Text("项目地图"),
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Flexible(
          child: Column(children: [
            Image(image: AssetImage('assets/images/mock_map.png'))
          ]),
        ),
      ),
    );
  }
}
