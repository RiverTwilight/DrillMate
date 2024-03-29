import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hgeology_app/models/project.dart';
import 'package:hgeology_app/pages/hole_list_page.dart';
import 'package:hgeology_app/pages/new_live_shot_page.dart';
import 'package:hgeology_app/services/project_service.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/custom_data_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
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

  Widget _buildTopCard() {
    return Card(
      color: Colors.black45, // Adjust the color for the dimmed effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Set your desired radius
        child: Container(
          height: 140, // Adjust the height as needed
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/artwork/red.jpeg'), // Replace with your artwork asset
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1), // Dimming effect
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '川西北油气勘探项目', // Replace with your title
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '2023/01/02 12:44:14', // Replace with your title
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: const LeadingBackButton(),
            title: width < 600 ? null : Text(_video!.title),
            elevation: 0.0,
            backgroundColor: Theme.of(context).canvasColor,
          ),
          body: _project == null
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildTopCard(),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     Expanded(
                            //         child: CardBase(
                            //       child: InkWell(
                            //         onTap: () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const NewLiveShotPage(),
                            //             ),
                            //           );
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 8),
                            //           child: Column(children: [
                            //             Icon(
                            //               Icons.camera_alt,
                            //               color: Colors.blue[800],
                            //             ),
                            //             Text("现场拍照"),
                            //           ]),
                            //         ),
                            //       ),
                            //     )),
                            //     Expanded(
                            //       child: CardBase(
                            //           child: InkWell(
                            //         onTap: () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const NewLiveShotPage(),
                            //             ),
                            //           );
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 8),
                            //           child: Column(children: [
                            //             Icon(
                            //               Icons.camera,
                            //               color: Colors.orange[600],
                            //             ),
                            //             Text("岩芯拍照"),
                            //           ]),
                            //         ),
                            //       )),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HoleListPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            CardBase(
                              child: InkWell(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    title: Text(
                                      "钻孔分布",
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
                                      "勘探列表",
                                    ),
                                    leading: const Icon(
                                      Icons.list,
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
                                      "勘探文档",
                                    ),
                                    leading: const Icon(
                                      Icons.book,
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
                                      "项目进度",
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
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                  );
                }),
        ),
      ],
    );
  }
}
