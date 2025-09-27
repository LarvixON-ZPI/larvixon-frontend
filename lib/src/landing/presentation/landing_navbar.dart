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
                    child: _NavBarButton(
                      label: context.translate.signIn,
                      onPressed: () => context.go(
                        AuthPage.route,
                        extra: {'mode': AuthFormMode.signIn},
                      ),
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
  const _Menu({super.key});

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
          child: Text(context.translate.about),
        ),
        PopupMenuItem(
          value: ContactPage.route,
          child: Text(context.translate.contact),
        ),
      ],
    );
  }
}

class _LogoButton extends StatelessWidget {
  const _LogoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(LandingPage.route),
      child: Text(
        context.translate.larvixon,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final List<_NavBarButton>? subButtons;
  final Color? textColor;

  const _NavBarButton({
    super.key,
    required this.label,
    this.onPressed,
    this.subButtons,
    this.textColor = Colors.white,
  });
  bool get hasSub => subButtons != null && subButtons!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!hasSub) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: textColor),
        child: Text(label),
      );
    }
    return PopupMenuButton<int>(
      color: Colors.white,
      offset: const Offset(-10, 30),
      tooltip: null,
      onSelected: (value) {
        subButtons![value].onPressed?.call();
      },

      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemBuilder: (context) {
        return subButtons!.asMap().entries.map((entry) {
          final index = entry.key;
          final button = entry.value;
          return PopupMenuItem<int>(value: index, child: Text(button.label));
        }).toList();
      },
      child: Text(label),
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
