import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_button.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_base.dart';
import 'package:larvixon_frontend/src/common/widgets/larvixon_logo.dart';
import 'package:larvixon_frontend/src/about_us/presentation/pages/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';

class LandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LandingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBase(
      title: LarvixonLogo(onPressed: () => context.go(LandingPage.route)),
      menu: _Menu(),
      rightChild: AppBarButton(
        label: context.translate.signIn,
        onPressed: () =>
            context.go(AuthPage.route, extra: {'mode': AuthFormMode.signIn}),
      ),
      children: [
        AppBarButton(
          label: context.translate.about,
          onPressed: () => context.go(AboutPage.route),
        ),
        AppBarButton(
          label: context.translate.contact,
          onPressed: () => context.go(ContactPage.route),
        ),
        AppBarButton(
          label: context.translate.signIn,
          onPressed: () =>
              context.go(AuthPage.route, extra: {'mode': AuthFormMode.signIn}),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
