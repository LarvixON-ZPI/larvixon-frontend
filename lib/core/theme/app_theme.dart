import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Colors.teal,
  scaffoldBackgroundColor: Colors.grey[50],
  textTheme: TextStyles.textTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.teal,
    titleTextStyle: TextStyles.title,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: AppColors.error, width: 2.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
    ),
  ),
);
