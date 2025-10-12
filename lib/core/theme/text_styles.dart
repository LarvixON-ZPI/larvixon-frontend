import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(fontSize: 16);

  static const TextStyle bodySmall = TextStyle(fontSize: 14);

  static const TextTheme textTheme = TextTheme(
    headlineLarge: headline,
    titleMedium: title,
    bodyLarge: body,
    bodySmall: bodySmall,
  );
}
