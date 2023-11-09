import 'package:flutter/material.dart';

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left_rounded,
        size: 30.0,
      ),
      onPressed: () {
        // if (_localVideoController != null) {
        //   _localVideoController.dispose();
        // }
        Navigator.pop(context);
      },
    );
  }
}
