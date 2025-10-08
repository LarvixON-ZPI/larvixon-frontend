import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/about/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';

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
      icon: const Icon(Icons.menu),

      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            context.go(AboutPage.route);
          },
          child: Text(context.translate.about),
        ),
        PopupMenuItem(
          onTap: () {
            context.go(ContactPage.route);
          },
          child: Text(context.translate.contact),
        ),
        PopupMenuItem(child: LocaleDropdownMenu()),
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
