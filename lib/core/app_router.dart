import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../src/authentication/bloc/auth_bloc.dart';
import '../src/authentication/presentation/auth_page.dart';
import '../src/authentication/presentation/signin_form.dart';
import '../src/authentication/presentation/auth_form.dart';
import '../src/home/home_page.dart';

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
    initialLocation: HomePage.route,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    routes: [
      GoRoute(
        name: AuthPage.name,
        path: AuthPage.route,
        builder: (context, state) {
          return AuthPage();
        },
      ),
      GoRoute(path: HomePage.route, builder: (_, state) => const HomePage()),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final loggedIn = authState.status == AuthStatus.authenticated;
      final loggingIn = state.path == AuthPage.route;
      if (!loggedIn && !loggingIn) {
        return AuthPage.route;
      }
      if (loggedIn && loggingIn) {
        return HomePage.route;
      }
      return null;
    },
  );
}
