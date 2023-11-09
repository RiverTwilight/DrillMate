import 'package:flutter/material.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class TipCard extends StatelessWidget {
  final String text;
  final String variant;
  final VoidCallback? handleLearnMore;
  final VoidCallback? onTap;

  const TipCard({
    super.key,
    required this.text,
    required this.variant,
    this.onTap,
    this.handleLearnMore,
  });

  Color _getIconColor() {
    switch (variant) {
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Row(children: [
            Icon(Icons.info, color: _getIconColor()),
            const SizedBox(
                width: 10), // for some space between the icon and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                  if (handleLearnMore != null)
                    InkWell(
                      onTap: handleLearnMore,
                      child: Text(
                        t.general.learnMore,
                        style: TextStyle(
                          color: Colors.blue[600],
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
