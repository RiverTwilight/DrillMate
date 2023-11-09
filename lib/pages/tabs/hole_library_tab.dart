import 'package:flutter/material.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/review_page.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/bookmark_provider.dart';
import 'package:hgeology_app/pages/bookmark_detail_page.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:hgeology_app/pages/search_page.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:hgeology_app/widget/bilibili_player_flutter/player/bilibili_player.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class HoleLibraryPage extends ConsumerStatefulWidget {
  const HoleLibraryPage({super.key});

  @override
  _HoleLibraryPageState createState() => _HoleLibraryPageState();
}

class _HoleLibraryPageState extends ConsumerState<HoleLibraryPage> {
  late MediaController _mediaController;
  Bookmark? _currentBookmark;
  String? filterTag;

  Video? _video;
  late MediaType _mediaType;
  bool _isPlaying = false;
  bool _isBuffering = false;

  void _pause() {
    _mediaController.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Widget _buildPlayer(BuildContext context) {
    if (_video == null) {
      return Container();
    }
    if (_mediaType == MediaType.youtube) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          onReady: () {
            _mediaController
                .seekTo(Duration(seconds: _video!.lastPlayPosition));
          },
          controller: _mediaController.activeController,
        ),
        builder: (context, player) {
          return player;
        },
      );
    } else if (_mediaType == MediaType.bilibili) {
      return BilibiliPlayerBuilder(
        player: BilibiliPlayer(
          onReady: () {
            _mediaController
                .seekTo(Duration(seconds: _video!.lastPlayPosition));
          },
          controller: _mediaController.activeController,
        ),
        builder: (context, player) {
          return player;
        },
      );
    } else if (_mediaType == MediaType.localVideo) {
      return AspectRatio(
        aspectRatio: _mediaController.aspectRatio > 1.0
            ? _mediaController.aspectRatio
            : 1.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_mediaController.activeController),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _playBookmark(Bookmark bookmark) async {
    final videoManager = ref.read(videoProvider);

    if (_video != null) {
      _mediaController.pause();
    }

    final targetMedia = videoManager.getVideo(bookmark.videoId);

    if (targetMedia == _video) {
      _mediaController.seekTo(Duration(seconds: bookmark.startAt));
      _mediaController.play();
      setState(() {
        _currentBookmark = bookmark;
        _isPlaying = true;
      });
    } else {
      setState(() {
        _currentBookmark = bookmark;
        _isPlaying = true;
        _isBuffering = true;
        _video = targetMedia;
      });

      _mediaType = targetMedia.mediaType;

      _mediaController = MediaController(_mediaType, false);

      print("Start play ${bookmark.videoId}, Type: ${targetMedia.mediaType}");

      final String loadablePath = await targetMedia.loadablePath;

      _mediaController.initialize(loadablePath).then((_) {
        _mediaController.seekTo(Duration(seconds: bookmark.startAt));
        _mediaController.play();
        _mediaController.addListener(_mediaControllerListener);
        setState(() {
          _isBuffering = false;
        });
      });
    }
  }

  void _mediaControllerListener() {
    if (_mediaController.currentPositionInSeconds >= _currentBookmark!.endAt) {
      _mediaController.seekTo(Duration(seconds: _currentBookmark!.startAt));
    }
  }

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
    final filteredBookmarks = _getFilteredBookmarks(bookmarkManager);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.track_changes_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReviewPage(),
              ),
            );
          },
        ),
        title: Text(t.memoLibraryPage.title),
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
            children: [
              SizedBox(
                width: 0,
                height: 0,
                child: _buildPlayer(context),
              ),
              DropdownButton<String>(
                value: filterTag,
                hint: Text('Filter by tag'),
                items: dropdownMenuItems,
                onChanged: (value) {
                  setState(() {
                    filterTag = value;
                  });
                },
              ),
              Expanded(
                child: ListView(
                  children: filteredBookmarks.map((bookmark) {
                    final fatherMedia = videoManager.getVideo(bookmark.videoId);

                    return Dismissible(
                      key: Key(bookmark.id),
                      background: Container(
                          color: Colors
                              .red), // The color behind the item when swiping.
                      direction: DismissDirection
                          .endToStart, // Allows swiping from right to left.
                      onDismissed: (direction) {
                        // Here's where you implement what happens when item is swiped off.
                        // For example, you might want to delete the item from the list and then show a snackbar.
                        setState(() {
                          filteredBookmarks.remove(bookmark);
                        });
                        bookmarkManager.removeBookmark(bookmark.id);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text("${bookmark.title} dismissed")),
                        // );
                      },
                      child: ListTile(
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
                        title: Row(children: [
                          Expanded(
                            child: Text(
                              bookmark.title,
                              overflow: TextOverflow
                                  .ellipsis, // This will work inside Expanded
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (bookmark.note != "")
                            Icon(
                              Icons.sticky_note_2_rounded,
                              size: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          if (bookmark.favorite)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.yellow[800],
                                )
                              ],
                            )
                        ]),
                        subtitle: Text(fatherMedia.title),
                        trailing: (_isPlaying &&
                                _isBuffering &&
                                _currentBookmark!.id == bookmark.id)
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon: (_isPlaying &&
                                        _currentBookmark!.id == bookmark.id)
                                    ? const Icon(Icons.pause_rounded)
                                    : const Icon(Icons.play_arrow_rounded),
                                onPressed: () {
                                  if (_isPlaying &&
                                      _currentBookmark!.id == bookmark.id) {
                                    _pause();
                                  } else {
                                    _playBookmark(bookmark);
                                  }
                                },
                              ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //     color: Colors.black,
        //     height: 50.0,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: _playPreviousBookmark,
        //           icon: Icon(Icons.skip_previous, color: Colors.white),
        //         ),
        //         IconButton(
        //           onPressed: () {},
        //           icon: Icon(
        //             _isPlaying ? Icons.pause : Icons.play_arrow,
        //             color: Colors.white,
        //           ),
        //         ),
        //         IconButton(
        //           onPressed: _playNextBookmark,
        //           icon: Icon(Icons.skip_next, color: Colors.white),
        //         ),
        //         Text(
        //           _currentBookmark?.title ?? 'No bookmark',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ]),
    );
  }

  void _playPreviousBookmark() {
    // Implement your logic to play the previous bookmark here.
  }

  void _playNextBookmark() {
    // Implement your logic to play the next bookmark here.
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
