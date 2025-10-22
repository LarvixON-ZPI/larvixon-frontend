import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'package:larvixon_frontend/src/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _brightnessKey = 'brightness';
  static const _languageCode = 'languageKey';

  @override
  TaskEither<Failure, Locale> getLanguage() => TaskEither.tryCatch(
    () async {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_languageCode);
      if (stored != null) {
        return Locale(stored);
      }
      final systemLocale = PlatformDispatcher.instance.locale;
      return systemLocale;
    },
    (e, _) {
      return Failure(message: e.toString());
    },
  );

  @override
  TaskEither<Failure, ThemeMode> getThemeMode() => TaskEither.tryCatch(
    () async {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_brightnessKey);
      if (stored != null) {
        return ThemeMode.values.byName(stored);
      }

      return ThemeMode.system;
    },
    (e, _) {
      return Failure(message: e.toString());
    },
  );

  @override
  TaskEither<Failure, void> setLanguage(Locale locale) => TaskEither.tryCatch(
    () async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_languageCode, locale.languageCode);
    },
    (e, _) {
      return Failure(message: e.toString());
    },
  );

  @override
  TaskEither<Failure, void> setThemeMode({required ThemeMode themeMode}) =>
      TaskEither.tryCatch(
        () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(_brightnessKey, themeMode.name);
        },
        (e, _) {
          return Failure(message: e.toString());
        },
      );
}
