import 'package:flutter/material.dart';
import 'dart:math';

List<Color> backgroundColors = [
  hexStringToColor("#4565C4"),
  hexStringToColor("#4ECB66"),
  hexStringToColor("#F36368"),
  hexStringToColor("#818B97"),
  hexStringToColor("#3AC454"),
  hexStringToColor("#00B4F6"),
  hexStringToColor("#00CBA8"),
  hexStringToColor("#BA76E4"),
  hexStringToColor("#8452C0"),
  hexStringToColor("#00CCa9"),
  hexStringToColor("#4162C3"),
  hexStringToColor("#F8AB59"),
];

Color getRandomBgColor() {
  Random random = Random();
  return backgroundColors[random.nextInt(backgroundColors.length)];
}

Color hexStringToColor(String hexString) {
  String colorString = hexString.replaceAll('#', ''); //removes the #
  int colorInt = int.parse(colorString,
      radix: 16); //parses the string into a hexadecimal integer
  return Color(colorInt).withOpacity(1.0); //creates a new Color object
}

String colorToHexString(Color color) {
  int r = color.red;
  int g = color.green;
  int b = color.blue;
  // Convert them to hex string and concatenate
  return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
}
