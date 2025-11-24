import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/common_icons.dart';
import 'package:larvixon_frontend/src/about_us/presentation/pages/about_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/pages/privacy_page.dart';
import 'package:larvixon_frontend/src/common/pages/terms_page.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/nav_item.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/nav_menu.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/app_bar_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/larvixon_logo.dart';
import 'package:larvixon_frontend/src/contact/presentation/pages/contact_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/pages/settings_page.dart';
import 'package:larvixon_frontend/src/simulation/presentation/pages/simulation_page.dart';
import 'package:larvixon_frontend/src/user/presentation/pages/account_page.dart';

class LarvixonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LarvixonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = buildNavItems(context);
    return AppBarBase(
      title: LarvixonLogo(
        onPressed: () => context.go(AnalysesOverviewPage.route),
      ),
      menu: NavMenu(items),
      children: items
          .map(
            (i) => TextButton.icon(
              icon: Icon(i.icon),
              onPressed: i.onTap ?? () => context.go(i.route),
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
        label: context.translate.analyses,
        icon: CommonIcons.analyses,
        route: AnalysesOverviewPage.route,
      ),
      NavItem(
        label: context.translate.simulation,
        icon: CommonIcons.simulation,
        route: SimulationPage.route,
      ),
      NavItem(
        label: context.translate.contact,
        icon: CommonIcons.contact,
        route: ContactPage.route,
      ),
      NavItem(
        label: context.translate.about,
        icon: CommonIcons.aboutUs,
        route: AboutPage.route,
      ),

      NavItem(
        label: context.translate.account,
        icon: CommonIcons.account,
        route: AccountPage.route,
      ),
      NavItem(
        label: context.translate.privacy,
        icon: Icons.privacy_tip_rounded,
        route: PrivacyPolicyPage.route,
      ),
      NavItem(
        label: context.translate.terms,
        icon: Icons.description_outlined,
        route: TermsOfUsePage.route,
      ),
      NavItem(
        label: context.translate.settings,
        icon: CommonIcons.settings,
        route: SettingsPage.route,
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
