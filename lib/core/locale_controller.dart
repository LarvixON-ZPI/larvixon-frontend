import 'package:flutter/material.dart';

class LocaleController extends InheritedWidget {
  final Locale? locale;
  final ValueChanged<Locale> setLocale;

  const LocaleController({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  static LocaleController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleController>();
  }

  @override
  bool updateShouldNotify(LocaleController oldWidget) =>
      locale != oldWidget.locale;
}
