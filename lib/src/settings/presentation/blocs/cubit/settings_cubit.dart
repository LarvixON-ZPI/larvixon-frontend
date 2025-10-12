// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/settings/domain/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;
  final List<Locale> supportedLocales;
  SettingsCubit({required this.repository, required this.supportedLocales})
    : super(SettingsState(locale: Locale('en'), theme: ThemeMode.system));

  Future<void> loadSettings() async {
    // Maybe they should be chained?
    final localeResult = await repository.getLanguage().run();
    final themeResult = await repository.getThemeMode().run();

    localeResult.match((failure) {}, (locale) {
      final isSupported = supportedLocales.contains(locale);
      emit(state.copyWith(locale: isSupported ? locale : Locale('en')));
    });

    themeResult.match((failure) {}, (theme) {
      emit(state.copyWith(theme: theme));
    });
  }

  Future<void> setLocale({required Locale locale}) async {
    if (!supportedLocales.contains(locale)) return;
    final localeResult = await repository.setLanguage(locale).run();
    localeResult.match((failure) {}, (success) {
      emit(state.copyWith(locale: locale));
    });
  }

  Future<void> toggleTheme() async {
    ThemeMode toggleTo;
    switch (state.theme) {
      case ThemeMode.system:
        toggleTo =
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark;
      case ThemeMode.light:
        toggleTo = ThemeMode.dark;
      case ThemeMode.dark:
        toggleTo = ThemeMode.light;
    }

    final result = await repository
        .setThemeMode(themeMode: toggleTo)
        .flatMap((_) => repository.getThemeMode())
        .run();

    result.match((e) {}, (theme) {
      emit(state.copyWith(theme: theme));
    });
  }

  Future<void> setTheme({required ThemeMode theme}) async {
    final result = await repository
        .setThemeMode(themeMode: theme)
        .flatMap((_) => repository.getThemeMode())
        .run();
    result.match((e) {}, (theme) {
      emit(state.copyWith(theme: theme));
    });
  }
}
