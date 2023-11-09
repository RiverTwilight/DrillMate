import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/models/showcase.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/store_provider.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/widget/case_item.dart';
import 'package:uuid/uuid.dart';

class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      StoreProvider storeManager = ref.read(storeProvider);

      storeManager.loadCases();
    });
  }

  void _addToLibrary(Showcase caseItem) async {
    final videoManager = ref.read(videoProvider);
    final bookmarkManager = ref.read(bookmarkProvider);

    String newId = const Uuid().v4();

    Video media = Video(
      id: newId,
      title: caseItem.title,
      sourceUrl: caseItem.sourceUrl,
      thumbnailUrl: caseItem.coverUrl,
      createDate: DateTime.now(),
      lastOpendedDate: DateTime.now(),
    );

    await videoManager.addVideo(media);

    List<Bookmark> updatedBookmarks = caseItem.bookmarks
        .map((bookmark) => Bookmark(
              id: const Uuid().v4(), // Update id
              title: bookmark.title,
              note: bookmark.note,
              videoId: newId, // Set to newId
              startAt: bookmark.startAt,
              endAt: bookmark.endAt,
              tags: bookmark.tags,
              createDate: bookmark.createDate,
              updateDate: bookmark.updateDate,
              favorite: bookmark.favorite,
            ))
        .toList();

    await bookmarkManager.addBookmark(bookmarks: updatedBookmarks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.newMediaPage.finishImport),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Showcase> allCases = ref.watch(storeProvider).cases;
    bool finishLoading = ref.watch(storeProvider).finishLoading;
    List<String> allTags =
        allCases.expand((showcase) => showcase.tags).toSet().toList();
    List<Showcase> filteredCases = selectedTags.isEmpty
        ? allCases
        : allCases
            .where((showcase) =>
                showcase.tags.any((tag) => selectedTags.contains(tag)))
            .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ['All', ...allTags].length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  String tag = ['All', ...allTags][index];
                  bool isSelected = selectedTags.contains(tag) ||
                      (tag == 'All' && selectedTags.isEmpty);

                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (tag == 'All') {
                          selectedTags.clear();
                        } else {
                          selectedTags.contains(tag)
                              ? selectedTags.remove(tag)
                              : selectedTags.add(tag);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            if (allCases.isEmpty && finishLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(t.mediaLibraryTab.emptyHint)],
                ),
              ),
            if (allCases.isEmpty && !finishLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            if (allCases.isNotEmpty)
              GridView.builder(
                // padding: const EdgeInsets.all(0),
                itemCount: filteredCases.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (MediaQuery.of(context).size.width > 600) ? 3 : 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 6,
                    childAspectRatio: 200 / 74),
                itemBuilder: (ctx, i) =>
                    CaseItem(filteredCases[i], _addToLibrary),
              ),
          ],
        ),
      ),
    );
  }
}
