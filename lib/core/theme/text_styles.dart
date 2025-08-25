import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle body = TextStyle(fontSize: 16, color: Colors.black87);

  static const TextStyle subtitle = TextStyle(fontSize: 14, color: Colors.grey);

  static const TextTheme textTheme = TextTheme(
    headlineLarge: headline, 
    titleMedium: title, 
    bodyLarge: body, 
    bodySmall: subtitle, 
  );
}
