// lib/src/common/widgets/adaptive_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/home/larvixon_app_bar.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing_appbar.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.status == AuthStatus.authenticated,
      builder: (context, isLoggedIn) {
        return isLoggedIn ? const LarvixonAppBar() : const LandingAppBar();
      },
    );
  }
}
