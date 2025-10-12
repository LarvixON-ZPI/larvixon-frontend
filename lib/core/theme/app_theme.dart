import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static final splashFactory = NoSplash.splashFactory;
  static final hoverColor = Colors.transparent;
  static final highlightColor = Colors.transparent;
  static final focusColor = Colors.transparent;
  static final fontFamily = GoogleFonts.oswald().fontFamily;
  static final inputDecorationTheme = InputDecorationTheme(
    filled: true,

    errorStyle: const TextStyle(height: 1.0),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(width: 2.0),
    ),
  );
  static const appBarTheme = AppBarTheme(titleTextStyle: TextStyles.title);
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
    ),
  );
  static final textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      mouseCursor: WidgetStateProperty.resolveWith(
        (states) => SystemMouseCursors.click,
      ),
    ),
  );

  static final appThemeLight = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: AppColors.colorSchemeLight,

    splashFactory: splashFactory,
    hoverColor: hoverColor,
    highlightColor: highlightColor,
    focusColor: focusColor,
    textTheme: GoogleFonts.oswaldTextTheme(ThemeData.light().textTheme),
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonTheme,
  );
  static final appThemeDark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: AppColors.colorSchemeDark,

    splashFactory: splashFactory,
    hoverColor: hoverColor,
    highlightColor: highlightColor,
    focusColor: focusColor,
    textTheme: GoogleFonts.oswaldTextTheme(ThemeData.dark().textTheme),
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonTheme,
  );
}
