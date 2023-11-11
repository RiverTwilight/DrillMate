import 'package:flutter/material.dart';

class OutlinedBadge extends StatelessWidget {
  final double size;
  final String text;

  const OutlinedBadge({super.key, this.size = 18.0, this.text = "已上传"});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: size,
          ),
        ),
      ),
    );
  }
}
