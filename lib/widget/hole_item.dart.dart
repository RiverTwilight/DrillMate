import 'package:flutter/material.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/pages/media_detail_page.dart';
import 'package:intl/intl.dart';

// Please let the item show these attributes. Consider the visual level of different
// data.
class HoleItem extends StatelessWidget {
  final Video video;
  final int bookmarkCount;
  final Function handleDelete;

  const HoleItem(this.video,
      {this.bookmarkCount = 0, required this.handleDelete, super.key});

  Widget _buildCoverPlaceholder(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return (AspectRatio(
      aspectRatio: 4 / 3,
      child: SizedBox(
        height: double.maxFinite,
        width: width < 600 ? 110 : 140,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            color: Colors.black,
            child: Center(
              child: Icon(
                video.mediaIcon,
                color: Colors.white30,
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediaDetailPage(
                videoId: video.id,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Dismissible(
            key: ValueKey(video.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              handleDelete(video.id);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Row(
              children: [
                _buildCoverPlaceholder(context),
                Expanded(
                  // Add the Expanded widget to properly align the text
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          video.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                        Text(
                          DateFormat('yMMMd')
                              .format(video.createDate.toLocal()),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.sticky_note_2_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              size: 14,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              bookmarkCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
