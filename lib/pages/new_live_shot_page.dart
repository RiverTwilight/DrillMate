import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hgeology_app/models/project.dart';
import 'package:hgeology_app/services/project_service.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/custom_data_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';

class NewLiveShotPage extends ConsumerStatefulWidget {
  final String projectId;

  const NewLiveShotPage({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  _NewLiveShotPageState createState() => _NewLiveShotPageState();
}

class _NewLiveShotPageState extends ConsumerState<NewLiveShotPage> {
  Video? _video;
  Project? _project;

  @override
  void initState() {
    super.initState();
    _fetchProjectDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchProjectDetail() async {
    // Assuming the ProjectDetailPage has a property 'projectId' which is passed to it.
    final projectId = widget.projectId;

    try {
      // Use your MockProjectService to fetch the project details.
      // Replace with your actual data fetching logic when ready.
      MockProjectService projectService = MockProjectService();
      Project project = await projectService.fetchProjectById(projectId);

      setState(() {
        _project = project;
      });
    } catch (e) {
      // Handle exceptions by showing a dialog or a snackbar
      print('Error fetching project details: $e');
    }
  }

  void _transcribe(BuildContext context) {}

  void _delete(BuildContext context) {}

  void _rename(BuildContext context) {}

  void _share(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: width < 600 ? null : Text(_video!.title),
        ),
        body: _project == null
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
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
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: CardBase(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue[800],
                                  ),
                                  Text("现场拍照"),
                                ]),
                              ),
                            )),
                            Expanded(
                                child: CardBase(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(children: [
                                  Icon(
                                    Icons.camera,
                                    color: Colors.orange[600],
                                  ),
                                  Text("岩芯拍照"),
                                ]),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
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
                        const SizedBox(
                          height: 12,
                        ),
                        CustomDataTable(
                          data: [
                            MapEntry("项目编号", "234523XG324"),
                            MapEntry("负责人/创建人", "王武"),
                            MapEntry("负责单位", "中建三局"),
                            MapEntry("工程类别", "地铁勘查类"),
                            MapEntry("经度", "14.51"),
                            MapEntry("纬度", "51.52"),
                            // ... Add more MapEntry objects as needed
                          ],
                        )
                      ]),
                    )
                  ],
                );
              }),
      ),
    ]);
  }
}
