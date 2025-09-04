import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../src/authentication/bloc/auth_bloc.dart';
import '../src/authentication/presentation/auth_form.dart';
import '../src/authentication/presentation/auth_page.dart';
import '../src/home/home_page.dart';
import '../src/landing/landing_page.dart';
import '../src/user/presentation/account_page.dart';

class GoRouterAuthNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _subscription;

  GoRouterAuthNotifier(this.authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final router = GoRouter(
    initialLocation: LandingPage.route,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    routes: [
      GoRoute(
        name: LandingPage.name,
        path: LandingPage.route,
        builder: (context, state) {
          return const LandingPage();
        },
      ),
      GoRoute(
        name: AuthPage.name,
        path: AuthPage.route,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};

          return AuthPage(
            initialMode: extra['mode'] as AuthFormMode? ?? AuthFormMode.signUp,
            initialEmail: extra['email'] as String?,
          );
        },
      ),
      GoRoute(path: HomePage.route, builder: (_, state) => const HomePage()),
      GoRoute(path: AccountPage.route, builder: (_, _) => const AccountPage()),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final loggingIn = state.uri.path == AuthPage.route;
      final onLanding = state.uri.path == LandingPage.route;

      switch (authState.status) {
        case AuthStatus.initial:
        case AuthStatus.unauthenticated:
          if (!loggingIn && !onLanding) return LandingPage.route;
          return null;
        case AuthStatus.authenticated:
          if (loggingIn || onLanding) return HomePage.route;
          return null;
        case AuthStatus.error:
        case AuthStatus.loading:
          return null;
      }
    },
  );
}
