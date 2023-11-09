import 'package:flutter/material.dart';

class CustomConstrainedBox extends StatelessWidget {
  final Widget child;

  const CustomConstrainedBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750), // For example, 800
        child: child,
      ),
    );
  }
}
