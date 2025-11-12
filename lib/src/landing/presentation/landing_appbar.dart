import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/about_us/presentation/pages/about_page.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/nav_item.dart';
import 'package:larvixon_frontend/src/common/nav_menu.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_base.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_button.dart';
import 'package:larvixon_frontend/src/common/widgets/larvixon_logo.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing/landing_page.dart';
import 'package:larvixon_frontend/src/simulation/presentation/pages/simulation_page.dart';

class LandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LandingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = buildNavItems(context);
    return AppBarBase(
      title: LarvixonLogo(onPressed: () => context.go(LandingPage.route)),
      menu: NavMenu(items),
      rightChild: AppBarButton(
        label: context.translate.signIn,
        onPressed: () =>
            context.go(AuthPage.route, extra: {'mode': AuthFormMode.signIn}),
      ),
      children: items
          .map(
            (i) => TextButton.icon(
              icon: Icon(i.icon),
              onPressed: i.onTap ?? () => context.go(i.route, extra: i.extra),
              label: Text(i.label),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).iconTheme.color,
              ),
            ),
          )
          .toList(),
    );
  }

  List<NavItem> buildNavItems(BuildContext context) {
    return [
      NavItem(
        label: context.translate.about,
        icon: FontAwesomeIcons.peopleGroup,
        route: AboutPage.route,
      ),
      NavItem(
        label: context.translate.contact,
        icon: FontAwesomeIcons.circleQuestion,
        route: ContactPage.route,
      ),
      NavItem(
        label: context.translate.simulation,
        icon: FontAwesomeIcons.gamepad,
        route: SimulationPage.route,
      ),

      NavItem(
        label: context.translate.signIn,
        icon: Icons.person,
        route: AuthPage.route,
        extra: {'mode': AuthFormMode.signIn},
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
