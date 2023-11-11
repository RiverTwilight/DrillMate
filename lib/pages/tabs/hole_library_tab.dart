import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/hole.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/pages/new_project_page.dart';
import 'package:hgeology_app/pages/search_page.dart';
import 'package:hgeology_app/services/project_service.dart';
import 'package:hgeology_app/widget/hole_item.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/widget/media_item.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class HoleLibraryPage extends ConsumerStatefulWidget {
  const HoleLibraryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HoleLibraryPage> createState() => _HoleLibraryPageState();
}

class _HoleLibraryPageState extends ConsumerState<HoleLibraryPage> {
  String dropdownValue = 'Recently';
  List<Hole> _holes = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(t.holeListTab.tabName),
      leading: const LeadingBackButton(),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search))
      ],
    );
  }

  Future<void> _refreshData() async {
    final projectService = MockProjectService();

    final fetchedProjects = await projectService.fetchHolesByProjectId("asdf");

    setState(() {
      _holes = fetchedProjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: _holes.isNotEmpty
              ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _holes.length,
                  itemBuilder: (ctx, i) => HoleItem(
                    hole: _holes[i],
                    onNavigate: (hole) {
                      // Navigate to HoleDetailPage or perform another action
                    },
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      Text(
                        'No holes found', // Update with your actual text
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                          'Please add new holes or refresh'), // Update with your actual text
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          // Navigate to add new hole page or perform another action
        },
      ),
    );
  }
}
