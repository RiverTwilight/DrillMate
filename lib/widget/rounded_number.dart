import 'package:flutter/material.dart';

class RoundedNumber extends StatelessWidget {
  final Color backgroundColor;
  final String numberStr;

  RoundedNumber({required this.backgroundColor, required this.numberStr});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 10,
      backgroundColor: backgroundColor,
      child: Text(
        numberStr,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
