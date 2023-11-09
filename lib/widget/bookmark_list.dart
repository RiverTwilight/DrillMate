import 'package:flutter/material.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/rounded_number.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:hgeology_app/pages/bookmark_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/gen/strings.g.dart';

typedef OnTapCallback = Function(Bookmark bookmark);
typedef OnWillPopCallback = void Function();

String convertSecondsToTimestamp(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

class BookmarkList extends ConsumerStatefulWidget {
  final String videoId;
  final OnTapCallback onTap;
  final bool isAutoplay;
  final VoidCallback handlePlayAll;
  final VoidCallback handleCancelPlayAll;
  final OnWillPopCallback? onWillPop;
  final int currentPositionInSeconds;

  const BookmarkList({
    super.key,
    required this.currentPositionInSeconds,
    required this.videoId,
    required this.onTap,
    required this.isAutoplay,
    required this.handlePlayAll,
    required this.handleCancelPlayAll,
    this.onWillPop,
  });

  @override
  _BookmarkListState createState() => _BookmarkListState();
}

class _BookmarkListState extends ConsumerState<BookmarkList> {
  late ScrollController _scrollController;
  late int _currentBookmarkIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant BookmarkList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bookmarkManager = ref.watch(bookmarkProvider);
    final allBookmarks = bookmarkManager.getAllBookmarkByMedia(widget.videoId);

    if (allBookmarks.isNotEmpty &&
        widget.currentPositionInSeconds != oldWidget.currentPositionInSeconds) {
      final currentBookmarkIndex = bookmarkManager.bookmarks.indexWhere(
          (bookmark) =>
              widget.currentPositionInSeconds >= bookmark.startAt &&
              widget.currentPositionInSeconds <= bookmark.endAt);

      if (currentBookmarkIndex != _currentBookmarkIndex &&
          currentBookmarkIndex != -1 &&
          currentBookmarkIndex <= bookmarkManager.bookmarks.length - 4) {
        _currentBookmarkIndex = currentBookmarkIndex;

        final itemPositionOffset = _currentBookmarkIndex * 56.0;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;

        _scrollController.animateTo(
          itemPositionOffset > maxScrollExtent
              ? maxScrollExtent
              : itemPositionOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);

    List<Bookmark> bookmarks = bookmarkManager.bookmarks
        .where((element) => element.videoId == widget.videoId)
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (bookmarks.isEmpty) {
      return Center(
        child: SizedBox(
            width: 280,
            height: 220,
            child: CardBase(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.mediaDetailPage.captureHint.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        RoundedNumber(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            numberStr: '1'),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(t.mediaDetailPage.captureHint.expression)
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        RoundedNumber(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            numberStr: '2'),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(t.mediaDetailPage.captureHint.phrase)
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        RoundedNumber(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            numberStr: '3'),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(t.mediaDetailPage.captureHint.anything)
                      ]),
                    ],
                  )),
            )),
      );
    }

    return Timeline.builder(
      itemCount: bookmarks.length + 1,
      iconSize: 1,
      lineColor:
          Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.4),
      controller: _scrollController,
      itemBuilder: (_, i) {
        if (i == 0) {
          return TimelineModel(
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
              child: InkWell(
                onTap: widget.isAutoplay
                    ? widget.handleCancelPlayAll
                    : widget.handlePlayAll,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.transparent,
                  title: widget.isAutoplay
                      ? Text(t.mediaDetailPage.stopPlayAll)
                      : Text(t.mediaDetailPage.playAll),
                ),
              ),
            ),
            position: TimelineItemPosition.right,
            iconBackground: Colors.grey,
            icon: Icon(
              Icons.play_arrow_rounded,
              size: 8,
              color: Colors.grey,
            ),
          );
        }

        final realMemoIndex = i - 1;
        Bookmark bookmark = bookmarks[realMemoIndex];
        final bool isCurrent =
            widget.currentPositionInSeconds >= bookmark.startAt &&
                widget.currentPositionInSeconds <= bookmark.endAt;

        return TimelineModel(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
            child: InkWell(
              onTap: () => widget.onTap(bookmarks[realMemoIndex]),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                tileColor: isCurrent
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                title: AnimatedDefaultTextStyle(
                  style: TextStyle(
                      fontSize: isCurrent ? 20.0 : 16.0,
                      color: Theme.of(context).colorScheme.onSurface),
                  duration: const Duration(milliseconds: 200),
                  child: Text(bookmark.title),
                ),
                // subtitle: AnimatedDefaultTextStyle(
                //   style: TextStyle(
                //       fontSize: isCurrent ? 18.0 : 14.0,
                //       color: Theme.of(context).colorScheme.onSurface),
                //   duration: const Duration(milliseconds: 200),
                //   child: Text(
                //       '${convertSecondsToTimestamp(bookmark.startAt)} - ${convertSecondsToTimestamp(bookmark.endAt)}'),
                // ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.edit_document,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
                  onPressed: () {
                    widget.onWillPop!();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookmarkDetailPage(
                          bookmark: bookmark,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          position: TimelineItemPosition.right,
          iconBackground:
              isCurrent ? Theme.of(context).primaryColor : Colors.grey,
          icon: Icon(
            Icons.fiber_manual_record,
            size: 8,
            color: isCurrent ? Theme.of(context).primaryColor : Colors.grey,
          ),
        );
      },
      position: TimelinePosition.Left,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
