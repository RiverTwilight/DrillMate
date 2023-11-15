import 'package:flutter/material.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/review_page.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/bookmark_provider.dart';
import 'package:hgeology_app/pages/bookmark_detail_page.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:hgeology_app/pages/search_page.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  late MediaController _mediaController;
  Bookmark? _currentBookmark;
  String? filterTag;

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final videoManager = ref.watch(videoProvider);

    final dropdownMenuItems = [
      DropdownMenuItem(
        value: "All",
        child: Text("All"),
      ),
      ..._getDropdownMenuItems(bookmarkManager)
    ];

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.track_changes_outlined),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const ReviewPage(),
        //       ),
        //     );
        //   },
        // ),
        title: Text("通讯录"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0),
          child: Column(
            children: [],
          ),
        ),
      ]),
    );
  }

  List<DropdownMenuItem<String>> _getDropdownMenuItems(
      BookmarkNotifier bookmarkManager) {
    return bookmarkManager.allTags.map((tag) {
      return DropdownMenuItem(
        value: tag,
        child: Text(tag),
      );
    }).toList();
  }

  List<Bookmark> _getFilteredBookmarks(BookmarkNotifier bookmarkManager) {
    List<Bookmark> filteredBookmarks;

    if (filterTag == null || filterTag!.isEmpty || filterTag == "All") {
      filteredBookmarks = bookmarkManager.bookmarks;
    } else {
      filteredBookmarks = bookmarkManager.bookmarks.where((bookmark) {
        return bookmark.tags.contains(filterTag);
      }).toList();
    }

    filteredBookmarks.sort((a, b) {
      if (b.favorite && !a.favorite) return 1;
      if (!b.favorite && a.favorite) return -1;
      return 0;
    });

    return filteredBookmarks;
  }

  @override
  void dispose() {
    if (_mediaController.isInitialized) {
      _mediaController.dispose();
    }
    super.dispose();
  }
}
