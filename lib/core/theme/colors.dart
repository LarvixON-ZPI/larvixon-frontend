import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.teal;
  static const Color primaryLight = Color(0xFF64FFDA);
  static const Color primaryDark = Color(0xFF00796B);

  static const Color background = Color(0xFFF5F5F5);
  static const Color card = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;

  static const Color error = Colors.red;
  static const Color success = Colors.green;

  static const inputFill = Color(0xFFEFEFEF);

  static final ColorScheme colorSchemeLight = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 255, 195),
  );
  static final ColorScheme colorSchemeDark = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 16, 97, 89),
    brightness: Brightness.dark,
  );
}
