import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/widget/bookmark_list.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class BookmarkDetailPage extends ConsumerStatefulWidget {
  final Bookmark bookmark;

  const BookmarkDetailPage({
    Key? key,
    required this.bookmark,
  }) : super(key: key);

  @override
  _EditBookmarkPageState createState() => _EditBookmarkPageState();
}

enum EditableAttribute { startTime, endTime }

class _EditBookmarkPageState extends ConsumerState<BookmarkDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late List<String> _tags;
  bool _isEditing = false;
  EditableAttribute _editingAttr = EditableAttribute.startTime;
  bool _markdownMode = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.bookmark.title);
    _noteController = TextEditingController(text: widget.bookmark.note);
    _tags = widget.bookmark.tags;

    _titleController.addListener(_updateTitle);
    _noteController.addListener(_updateNote);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateTitle() {
    final bookmarkManager = ref.watch(bookmarkProvider);

    final updatedBookmark = widget.bookmark.copy(title: _titleController.text);
    bookmarkManager.updateBookmark(updatedBookmark);
  }

  void _updateNote() {
    final bookmarkManager = ref.watch(bookmarkProvider);

    final updatedBookmark = widget.bookmark.copy(note: _noteController.text);
    bookmarkManager.updateBookmark(updatedBookmark);
  }

  void _updateTags(List<String> newTags) {
    final bookmarkManager = ref.read(bookmarkProvider);

    final updatedBookmark = widget.bookmark.copy(tags: newTags);
    bookmarkManager.updateBookmark(updatedBookmark);
  }

  void _updateStartTime(int newValue) {
    final bookmarkManager = ref.read(bookmarkProvider);

    final updatedBookmark = widget.bookmark.copy(startAt: newValue);
    bookmarkManager.updateBookmark(updatedBookmark);
  }

  void _updateEndTime(int newValue) {
    final bookmarkManager = ref.read(bookmarkProvider);

    final updatedBookmark = widget.bookmark.copy(endAt: newValue);
    bookmarkManager.updateBookmark(updatedBookmark);
  }

  void _handleUpdateTimestemp(int offset) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    Bookmark currentBookmark =
        bookmarkManager.getBookmarkById(widget.bookmark.id);

    switch (_editingAttr) {
      case EditableAttribute.startTime:
        if (currentBookmark.startAt >= 1) {
          _updateStartTime(currentBookmark.startAt + offset);
        }
        break;
      case EditableAttribute.endTime:
        _updateEndTime(currentBookmark.endAt + offset);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    Bookmark currentBookmark =
        bookmarkManager.getBookmarkById(widget.bookmark.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.bookmarkDetailPage.title),
        leading: const LeadingBackButton(),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                _isEditing = false;
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
                setState(() {}); // Refresh the UI to hide the "Done" button
              },
            ),
          if (!_isEditing)
            IconButton(
              icon: currentBookmark.favorite
                  ? const Icon(Icons.star_rounded, color: Colors.amber)
                  : const Icon(Icons.star_border),
              onPressed: () {
                bookmarkManager.favoriteBookmark(widget.bookmark.id);
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextFormField(
            controller: _titleController,
          ),
          const SizedBox(height: 16.0),
          if (!_markdownMode)
            Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  _isEditing = true;
                } else {
                  _isEditing = false;
                }
                setState(
                    () {}); // Refresh the UI to show/hide the "Done" button
              },
              child: TextFormField(
                minLines: 5,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Write your notes here.",
                  border: null,
                  fillColor: Colors.transparent,
                ),
                controller: _noteController,
              ),
            ),
          if (_markdownMode)
            CardBase(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      tabs: [
                        Tab(text: t.general.preview),
                        Tab(text: t.general.edit),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        children: <Widget>[
                          Markdown(
                            data: _noteController.text == ""
                                ? t.bookmarkDetailPage.noNoteHint
                                : _noteController.text,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                  _isEditing = true;
                                } else {
                                  _isEditing = false;
                                }
                                setState(
                                    () {}); // Refresh the UI to show/hide the "Done" button
                              },
                              child: TextFormField(
                                minLines: 3,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  border: null,
                                  fillColor: Colors.transparent,
                                ),
                                controller: _noteController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Checkbox(
                  value: _markdownMode,
                  onChanged: (value) {
                    setState(() {
                      _markdownMode = value!;
                    });
                  }),
              const Text("Markdown")
            ],
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ...bookmarkManager.allTags
                  .map((tag) => FilterChip(
                        label: Text(tag),
                        selectedColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        selected: currentBookmark.tags.contains(tag),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              widget.bookmark.tags.add(tag);
                            } else {
                              widget.bookmark.tags.remove(tag);
                            }
                            // You can call a method here to update the bookmark in your storage or API
                          });
                        },
                      ))
                  .toList(),
              IconButton(
                // label: Text(t.bookmarkDetailPage.tag.btn),
                onPressed: () {
                  TextEditingController tagController = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(t.bookmarkDetailPage.tag.dialogTitle),
                        content: TextField(
                          controller: tagController,
                          decoration: InputDecoration(
                            hintText: t.bookmarkDetailPage.tag.inputHint,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(t.general.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              String newTag = tagController.text.trim();
                              if (newTag.isNotEmpty) {
                                _updateTags([...widget.bookmark.tags, newTag]);
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text(t.general.add),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
          const SizedBox(height: 60.0),
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(t.bookmarkDetailPage.deleteConfirmTitle),
                    content: Text(t.bookmarkDetailPage.deleteConfirm),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(t.general.cancel),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary,
                          foregroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .onPrimary,
                        ),
                        onPressed: () {
                          bookmarkManager.removeBookmark(widget.bookmark.id);
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                        child: Text(t.general.confirm),
                      )
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete, color: Colors.red[400]),
            label: Text(
              t.bookmarkDetailPage.deleteStr,
              style: TextStyle(color: Colors.red[400]),
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(children: [
        Expanded(
            child: BottomAppBar(
                child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  _handleUpdateTimestemp(-1);
                },
                child: const Row(children: [
                  Icon(Icons.navigate_before_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Text("- 1s"),
                ]),
              ),
              FilterChip(
                showCheckmark: false,
                onSelected: (value) {
                  setState(() {
                    _editingAttr = EditableAttribute.startTime;
                  });
                },
                selected: _editingAttr == EditableAttribute.startTime,
                elevation: 1,
                label: Text(convertSecondsToTimestamp(currentBookmark.startAt)),
              ),
              const Text("-"),
              FilterChip(
                onSelected: (value) {
                  setState(() {
                    _editingAttr = EditableAttribute.endTime;
                  });
                },
                selected: _editingAttr == EditableAttribute.endTime,
                elevation: 1,
                showCheckmark: false,
                label: Text(convertSecondsToTimestamp(currentBookmark.endAt)),
              ),
              TextButton(
                onPressed: () {
                  _handleUpdateTimestemp(1);
                },
                child: const Row(children: [
                  Text("+ 1s"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.navigate_next_rounded)
                ]),
              ),
            ],
          ),
        )))
      ]),
    );
  }
}
