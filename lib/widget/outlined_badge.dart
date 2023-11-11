import 'package:flutter/material.dart';

class OutlinedBadge extends StatelessWidget {
  final double size;

  OutlinedBadge({this.size = 18.0});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary, // Outline color
          width: 1.0, // Outline width
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      color: Colors.transparent, // Transparent background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          "已上传",
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .primary, // Text color same as border color
            fontSize: size,
          ),
        ),
      ),
    );
  }
}
