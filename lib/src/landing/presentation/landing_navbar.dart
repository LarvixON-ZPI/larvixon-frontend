import 'package:flutter/material.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';

import '../../common/extensions/translate_extension.dart';

class LandingNavBar extends StatelessWidget {
  const LandingNavBar({
    super.key,
    this.onAboutPressed,
    this.onContactPressed,
    this.onSignInPressed,
    this.onLogoPressed,
    this.onLocaleChanged,
    this.currentLocale,
  });
  final VoidCallback? onAboutPressed;
  final VoidCallback? onContactPressed;
  final VoidCallback? onSignInPressed;
  final VoidCallback? onLogoPressed;
  final ValueChanged<Locale?>? onLocaleChanged;
  final Locale? currentLocale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Expanded(
            child: Text(
              context.translate.larvixon,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onAboutPressed,
                  child: Text(
                    context.translate.about,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: onContactPressed,
                  child: Text(
                    context.translate.contact,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 2),
                _buildLanguageDropdown(
                  currentLocale: currentLocale,
                  onLocaleChanged: onLocaleChanged,
                  context: context,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onSignInPressed,
                  child: Text(
                    context.translate.signIn,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLanguageDropdown({
  required Locale? currentLocale,
  required ValueChanged<Locale?>? onLocaleChanged,
  required BuildContext context,
}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton<Locale>(
      dropdownColor: Colors.grey[900],
      value: _getDropdownValue(currentLocale, context),
      icon: const Icon(Icons.language, color: Colors.white),
      items: AppLocalizations.supportedLocales
          .map(
            (locale) => DropdownMenuItem(
              value: locale,
              child: Text(
                locale.languageCode.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      onChanged: onLocaleChanged,
    ),
  );
}

Locale _getDropdownValue(Locale? currentLocale, BuildContext context) {
  if (AppLocalizations.supportedLocales.contains(currentLocale)) {
    return currentLocale!;
  } else if (AppLocalizations.supportedLocales.contains(
    Localizations.localeOf(context),
  )) {
    return Localizations.localeOf(context);
  } else {
    return AppLocalizations.supportedLocales.first;
  }
}
