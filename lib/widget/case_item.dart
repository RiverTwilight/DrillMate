import 'package:flutter/material.dart';
import 'package:hgeology_app/models/showcase.dart';
import 'package:hgeology_app/models/video.dart';
import 'package:hgeology_app/pages/media_detail_page.dart';
import 'package:hgeology_app/widget/card_base.dart';

class CaseItem extends StatelessWidget {
  final Showcase showcase;
  final Function(Showcase) handleAddToLibrary;

  const CaseItem(this.showcase, this.handleAddToLibrary, {super.key});

  @override
  Widget build(BuildContext context) {
    return CardBase(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    showcase.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    showcase.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton.filled(
                onPressed: () {
                  handleAddToLibrary(showcase);
                },
                icon: const Icon(Icons.playlist_add_rounded))
          ]),
        ),
      ),
    );
  }
}
