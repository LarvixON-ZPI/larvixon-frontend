import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/app_shell.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/larvixon_app_bar.dart';
import 'package:larvixon_frontend/src/landing/presentation/widgets/landing_appbar.dart';

class AdaptiveAppShell extends StatelessWidget {
  final Widget child;

  const AdaptiveAppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select(
      (AuthBloc bloc) => bloc.state.status == AuthStatus.authenticated,
    );

    return AppShell(
      appBar: isAuthenticated ? const LarvixonAppBar() : const LandingAppBar(),
      child: child,
    );
  }
}
