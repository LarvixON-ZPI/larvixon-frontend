part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final Locale locale;
  final ThemeMode theme;
  const SettingsState({required this.locale, required this.theme});

  @override
  List<Object> get props => [locale, theme];

  SettingsState copyWith({Locale? locale, ThemeMode? theme}) {
    return SettingsState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }
}
