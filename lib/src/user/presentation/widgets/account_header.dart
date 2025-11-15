import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_with_actions.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/action_item.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderWithActions(
      title: context.translate.account,
      fallbackRoute: AnalysesOverviewPage.route,
      compactBreakpoint: Breakpoints.small,
      actions: [
        ActionItem(
          label: context.translate.logout,
          icon: Icon(Icons.logout, color: Theme.of(context).iconTheme.color!),
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
          },
        ),
      ],
    );
  }
}
