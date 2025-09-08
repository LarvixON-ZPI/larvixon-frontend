import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextTheme textTheme = TextTheme(
    headlineLarge: headline,
    titleMedium: title,
    bodyLarge: body,
    bodySmall: bodySmall,
  );
}
