import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/about/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';

import '../../common/extensions/translate_extension.dart';

class LandingNavBar extends StatelessWidget {
  const LandingNavBar({super.key, this.onLocaleChanged, this.currentLocale});
  final ValueChanged<Locale?>? onLocaleChanged;
  final Locale? currentLocale;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 40,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < Breakpoints.medium;
                if (isNarrow) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Menu(),
                      const _LogoButton(),

                      _NavBarButton(
                        label: context.translate.signIn,
                        onPressed: () => context.go(
                          AuthPage.route,
                          extra: {'mode': AuthFormMode.signIn},
                        ),
                      ),
                    ],
                  );
                }

                return SizedBox.expand(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const _LogoButton(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                      _NavBarButton(
                        label: context.translate.signIn,
                        onPressed: () => context.go(
                          AuthPage.route,
                          extra: {'mode': AuthFormMode.signIn},
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => context.go(AboutPage.route),
          child: Text(context.translate.about),
        ),
        PopupMenuItem(
          onTap: () => context.go(ContactPage.route),
          child: Text(context.translate.contact),
        ),
        const PopupMenuItem(
          child: LocaleDropdownMenu(includeTrailingIcon: false),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }
}
