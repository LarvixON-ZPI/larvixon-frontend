import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/analysis_add_dialog.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_base.dart';
import 'package:larvixon_frontend/src/common/widgets/larvixon_logo.dart';
import 'package:larvixon_frontend/src/home/home_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/pages/settings_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';
import 'package:larvixon_frontend/src/user/presentation/account_page.dart';

class LarvixonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LarvixonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBase(
      title: LarvixonLogo(onPressed: () => context.go(HomePage.route)),
      menu: _Menu(),
      children: [
        IconButton(
          onPressed: () async {
            await LarvaVideoAddForm.showLarvaVideoDialog(
              context,
              context.read<AnalysisListCubit>(),
            );
          },
          icon: Icon(Icons.add, color: Theme.of(context).iconTheme.color!),
        ),

        IconButton(
          icon: Icon(Icons.logout, color: Theme.of(context).iconTheme.color!),
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color!),
          onPressed: () {
            context.go(SettingsPage.route);
          },
        ),
        IconButton(
          icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color!),
          onPressed: () {
            context.go(AccountPage.route);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
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
          onTap: () async {
            await LarvaVideoAddForm.showLarvaVideoDialog(
              context,
              context.read<AnalysisListCubit>(),
            );
          },
          child: Text(context.translate.analyzeNewVideo),
        ),
        PopupMenuItem(
          onTap: () {
            context.go(AccountPage.route);
          },
          child: Text(context.translate.account),
        ),
        PopupMenuItem(
          onTap: () => context.go(SettingsPage.route),
          child: Text(context.translate.settings),
        ),
        PopupMenuItem(
          onTap: () => context.read<AuthBloc>().add(AuthSignOutRequested()),
          child: Text(context.translate.logout),
        ),
      ],
    );
  }
}
