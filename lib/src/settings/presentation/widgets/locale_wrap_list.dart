import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';

class LocaleWrapList extends StatelessWidget {
  const LocaleWrapList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, Locale>(
      selector: (state) {
        return state.locale;
      },
      builder: (context, selectedLocale) {
        return Wrap(
          spacing: 8.0,

          children: AppLocalizations.supportedLocales.map((locale) {
            final isSelected = selectedLocale == locale;

            return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                foregroundColor: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                context.read<SettingsCubit>().setLocale(locale: locale);
              },
              child: Text(
                locale.languageCode.toUpperCase(),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
