import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/collection.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/pages/new_project_page.dart';
import 'package:hgeology_app/pages/search_page.dart';
import 'package:hgeology_app/widget/media_item.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class ProjectLibraryPage extends ConsumerStatefulWidget {
  const ProjectLibraryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProjectLibraryPage> createState() => _ProjectLibraryPageState();
}

class _ProjectLibraryPageState extends ConsumerState<ProjectLibraryPage> {
  String dropdownValue = 'Recently';

  @override
  void initState() {
    super.initState();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("项目"),
      leading: PopupMenuButton<String>(
        icon: const Icon(Icons.sort_rounded),
        onSelected: (String value) {
          setState(() {
            dropdownValue = value;
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Name',
            child: Row(children: [
              Icon(Icons.check_rounded,
                  color: dropdownValue == "Name"
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent),
              const SizedBox(
                width: 6,
              ),
              Text(t.mediaLibraryTab.sortMethod.name)
            ]),
          ),
          PopupMenuItem<String>(
            value: 'Date',
            child: Row(children: [
              Icon(Icons.check_rounded,
                  color: dropdownValue == "Date"
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent),
              const SizedBox(
                width: 6,
              ),
              Text(t.mediaLibraryTab.sortMethod.date)
            ]),
          ),
          PopupMenuItem<String>(
            value: 'Recently',
            child: Row(children: [
              Icon(Icons.check_rounded,
                  color: dropdownValue == "Recently"
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent),
              const SizedBox(
                width: 8,
              ),
              Text(t.mediaLibraryTab.sortMethod.recent)
            ]),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    final videoManager = ref.watch(videoProvider);
    final bookmarkManager = ref.watch(bookmarkProvider);

    List<Video> videos = videoManager.videos;
    final width = MediaQuery.of(context).size.width;

    switch (dropdownValue) {
      case "Recently":
        videos.sort((a, b) => b.lastOpendedDate.compareTo(a.lastOpendedDate));
      case "Date":
        videos.sort((a, b) => b.createDate.compareTo(a.createDate));
      default:
        videos.sort((a, b) => a.title.compareTo(b.title));
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: videos.isNotEmpty
            ? Stack(
                children: [
                  ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              'Collection',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              'Recently Viewed',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: videos.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: max(1, (width / 400).truncate()),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 6,
                            childAspectRatio:
                                width < 600 ? 200 / 56 : 200 / 50),
                        itemBuilder: (ctx, i) => VideoItem(
                          videos[i],
                          bookmarkCount: bookmarkManager
                              .getAllBookmarkByMedia(videos[i].id)
                              .length,
                          handleDelete: (String id) {
                            videoManager.deleteVideo(id);
                            bookmarkManager.removeBookmarkByMedia(id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/illustrations/snap_the_moment_re_88cu.png',
                      width: 200,
                    ),
                    Text(t.mediaLibraryTab.emptyHint)
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewProjectPage(),
            ),
          );
        },
      ),
    );
  }
}
