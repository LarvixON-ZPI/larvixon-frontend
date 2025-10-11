import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/analysis_add_dialog.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_base.dart';
import 'package:larvixon_frontend/src/common/widgets/larvixon_logo.dart';
import 'package:larvixon_frontend/src/home/home_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/pages/settings_page.dart';
import 'package:larvixon_frontend/src/user/presentation/account_page.dart';

class LarvixonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LarvixonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBase(
      title: LarvixonLogo(onPressed: () => context.go(HomePage.route)),
      children: [
        IconButton(
          onPressed: () async {
            await LarvaVideoAddForm.showLarvaVideoDialog(
              context,
              context.read<AnalysisListCubit>(),
            );
          },
          icon: const Icon(Icons.add),
        ),

        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            context.go(SettingsPage.route);
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
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
