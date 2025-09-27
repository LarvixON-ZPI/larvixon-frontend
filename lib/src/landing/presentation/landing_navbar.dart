import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/about/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';

import '../../common/extensions/translate_extension.dart';

typedef GetExtraFunction =
    Map<String, dynamic> Function(BuildContext context, String to);

class LandingNavBar extends StatelessWidget {
  const LandingNavBar({super.key, this.onLocaleChanged, this.currentLocale});
  final ValueChanged<Locale?>? onLocaleChanged;
  final Locale? currentLocale;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 80, minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < Breakpoints.medium;
            if (isNarrow) {
              return Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  Align(alignment: Alignment.centerLeft, child: _Menu()),
                  _LogoButton(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageDropdown(
                          currentLocale: currentLocale,
                          onLocaleChanged: onLocaleChanged,
                          context: context,
                        ),
                        const SizedBox(width: 8),
                        _NavBarButton(
                          label: context.translate.signIn,
                          onPressed: () => context.go(
                            AuthPage.route,
                            extra: {'mode': AuthFormMode.signIn},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _LogoButton(),
                Spacer(),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NavBarButton(
                      label: context.translate.about,
                      onPressed: () => context.go(AboutPage.route),
                    ),

                    _NavBarButton(
                      label: context.translate.contact,
                      onPressed: () => context.go(ContactPage.route),
                    ),
                    const SizedBox(width: 2),
                    _buildLanguageDropdown(
                      currentLocale: currentLocale,
                      onLocaleChanged: onLocaleChanged,
                      context: context,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _NavBarButton(
                      label: context.translate.signIn,
                      onPressed: () => context.go(
                        AuthPage.route,
                        extra: {'mode': AuthFormMode.signIn},
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      offset: const Offset(0, 40),
      icon: const Icon(Icons.menu, color: Colors.white),
      color: Colors.white,
      onSelected: (value) {
        context.go(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AboutPage.route,
          child: Text(
            context.translate.about,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: ContactPage.route,
          child: Text(
            context.translate.contact,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _LogoButton extends StatelessWidget {
  const _LogoButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(LandingPage.route),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        context.translate.larvixon,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _NavBarButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }
}

Widget _buildLanguageDropdown({
  required Locale? currentLocale,
  required ValueChanged<Locale?>? onLocaleChanged,
  required BuildContext context,
}) {
  final currentLanguage = _getDropdownValue(currentLocale, context);

  return PopupMenuButton<Locale>(
    tooltip: 'Select Language',
    offset: const Offset(-10, 30),
    color: Colors.grey[900],
    onSelected: (Locale selectedLocale) {
      onLocaleChanged?.call(selectedLocale);
    },
    itemBuilder: (context) {
      return AppLocalizations.supportedLocales.map((locale) {
        final isSelected = locale == currentLanguage;
        return PopupMenuItem<Locale>(
          value: locale,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                color: isSelected ? Colors.blue : Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                locale.languageCode.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check, color: Colors.blue, size: 16),
              ],
            ],
          ),
        );
      }).toList();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            currentLanguage.languageCode.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
        ],
      ),
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
