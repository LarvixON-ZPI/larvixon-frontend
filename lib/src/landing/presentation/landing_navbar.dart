import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/about/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';

import '../../common/extensions/translate_extension.dart';

class LandingNavBar extends StatelessWidget {
  const LandingNavBar({super.key});
  // TODO implement this while pushing new routes
  static const List<String> _navbarRoutes = [
    LandingPage.route,
    AboutPage.route,
    ContactPage.route,
    AuthPage.route,
  ];
  bool _shouldSlideRight(String from, String to) {
    final fromIndex = _navbarRoutes.indexOf(from);
    final toIndex = _navbarRoutes.indexOf(to);
    if (fromIndex == -1 || toIndex == -1) return true;
    return toIndex >= fromIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 80, minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            TextButton(
              onPressed: () => context.go(LandingPage.route),
              child: Text(
                context.translate.larvixon,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
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
                  onPressed: () => context.go(AuthPage.route),
                ),
              ],
            ),
          ],
        ),
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
