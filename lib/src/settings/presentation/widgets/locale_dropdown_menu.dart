import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';

class LocaleDropdownMenu extends StatelessWidget {
  final bool includeTrailingIcon;
  const LocaleDropdownMenu({super.key, this.includeTrailingIcon = true});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, Locale>(
      selector: (state) {
        return state.locale;
      },
      builder: (context, locale) {
        return DropdownMenu<Locale>(
          initialSelection: locale,
          leadingIcon: includeTrailingIcon ? const Icon(Icons.language) : null,
          enableSearch: false,
          requestFocusOnTap: false,
          inputDecorationTheme: InputDecorationTheme(
            isCollapsed: true,
            isDense: true,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
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
