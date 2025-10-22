
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';

abstract class SettingsRepository {
  TaskEither<Failure, Locale> getLanguage();
  TaskEither<Failure, ThemeMode> getThemeMode();
  TaskEither<Failure, void> setThemeMode({required ThemeMode themeMode});
  TaskEither<Failure, void> setLanguage(Locale locale);
}
