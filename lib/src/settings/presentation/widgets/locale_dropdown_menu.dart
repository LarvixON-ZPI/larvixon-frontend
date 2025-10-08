import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';

class LocaleDropdownMenu extends StatelessWidget {
  const LocaleDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, Locale>(
      selector: (state) {
        return state.locale;
      },
      builder: (context, locale) {
        return DropdownMenu(
          initialSelection: locale,
          leadingIcon: Icon(Icons.language),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.transparent,
          ),
          onSelected: (locale) {
            if (locale != null) {
              context.read<SettingsCubit>().setLocale(locale: locale);
            }
          },
          dropdownMenuEntries: AppLocalizations.supportedLocales.map((locale) {
            return DropdownMenuEntry(
              value: locale,
              label: locale.languageCode.toUpperCase(),
            );
          }).toList(),
        );
      },
    );
  }
}
