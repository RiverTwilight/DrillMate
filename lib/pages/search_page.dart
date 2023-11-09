import 'package:flutter/material.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/pages/bookmark_detail_page.dart';
import 'package:hgeology_app/pages/media_detail_page.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/models/bookmark.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Bookmark> _bookmarkSearchResults = [];
  List<Video> _videoSearchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final videoManager = ref.watch(videoProvider);

    if (_searchController.text == "") {
      setState(() {
        _bookmarkSearchResults = [];
        _videoSearchResults = [];
      });
    }

    setState(() {
      _bookmarkSearchResults =
          bookmarkManager.searchByContent(_searchController.text);
      _videoSearchResults = videoManager.searchByName(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            icon: const Icon(Icons.search),
            hintText: t.searchPage.inputHint,
          ),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              ..._bookmarkSearchResults.map((bookmark) {
                final fatherMedia =
                    ref.read(videoProvider.notifier).getVideo(bookmark.videoId);
                return ListTile(
                  title: Text(bookmark.title),
                  subtitle: Text(fatherMedia.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookmarkDetailPage(
                          bookmark: bookmark,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              ..._videoSearchResults.map((media) {
                return ListTile(
                  title: Text(media.title),
                  subtitle: Text("Media"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaDetailPage(
                          videoId: media.id,
                        ),
                      ),
                    );
                  },
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
