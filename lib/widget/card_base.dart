import 'package:flutter/material.dart';

class CardBase extends StatelessWidget {
  final Widget child;

  const CardBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
