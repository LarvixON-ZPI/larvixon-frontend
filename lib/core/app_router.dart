import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/not_found_page.dart';
import 'package:larvixon_frontend/core/transitions.dart';
import 'package:larvixon_frontend/src/about_us/presentation/pages/about_page.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analysis_details_page.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_page.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/app_shell.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/adaptive_app_bar.dart';
import 'package:larvixon_frontend/src/contact/presentation/pages/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/pages/landing_page.dart';
import 'package:larvixon_frontend/src/settings/presentation/pages/settings_page.dart';
import 'package:larvixon_frontend/src/simulation/presentation/pages/simulation_page.dart';
import 'package:larvixon_frontend/src/user/presentation/pages/account_page.dart';

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

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'Root',
  );
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell');

  late final router = GoRouter(
    initialLocation: LandingPage.route,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(appBar: const AdaptiveAppBar(), child: child);
        },
        routes: [
          // ==================== PUBLIC ROUTES ====================
          GoRoute(
            name: LandingPage.name,
            path: LandingPage.route,
            pageBuilder: (context, state) {
              return const LandingPage().withoutTransition(state: state);
            },
            redirect: (context, state) {
              if (authBloc.state.status == AuthStatus.authenticated) {
                return AnalysesOverviewPage.route;
              }
              return null;
            },
          ),
          GoRoute(
            name: ContactPage.name,
            path: ContactPage.route,
            pageBuilder: (context, state) {
              return const ContactPage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            name: AboutPage.name,
            path: AboutPage.route,
            pageBuilder: (context, state) {
              return const AboutPage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            name: SimulationPage.name,
            path: SimulationPage.route,
            pageBuilder: (context, state) {
              return const SimulationPage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            name: AuthPage.name,
            path: AuthPage.route,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final page = AuthPage(
                initialMode:
                    extra['mode'] as AuthFormMode? ?? AuthFormMode.signUp,
                initialEmail: extra['email'] as String?,
              );
              return page.withoutTransition(state: state);
            },
          ),

          // ==================== AUTHENTICATED ROUTES ====================
          GoRoute(
            path: AnalysesOverviewPage.route,
            name: AnalysesOverviewPage.name,
            pageBuilder: (context, state) {
              return BlocProvider(
                create: (context) => AnalysisListCubit(context.read()),
                child: const AnalysesOverviewPage(),
              ).withoutTransition(state: state);
            },
            routes: [
              GoRoute(
                path: AnalysisDetailsPage.route,
                name: AnalysisDetailsPage.name,
                redirect: (context, state) {
                  final analysisId = state.pathParameters['analysisId'];
                  if (analysisId == null) {
                    return AnalysesOverviewPage.route;
                  }
                  return null;
                },
                pageBuilder: (context, state) {
                  final analysisId = int.tryParse(
                    state.pathParameters['analysisId'] ?? '',
                  );
                  return AnalysisDetailsPage(
                    analysisId: analysisId,
                  ).withoutTransition(state: state);
                },
              ),
            ],
          ),
          GoRoute(
            path: AccountPage.route,
            name: AccountPage.name,
            pageBuilder: (context, state) {
              return const AccountPage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            path: SettingsPage.route,
            name: SettingsPage.name,
            pageBuilder: (context, state) {
              return const SettingsPage().withoutTransition(state: state);
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) {
      return const NotFoundPage().withoutTransition(state: state);
    },
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthRoute = state.uri.path == AuthPage.route;
      final isPublicRoute = [
        LandingPage.route,
        AboutPage.route,
        ContactPage.route,
        SimulationPage.route,
      ].contains(state.uri.path);

      switch (authState.status) {
        case AuthStatus.initial:
        case AuthStatus.unauthenticated:
          if (!isAuthRoute && !isPublicRoute) {
            return LandingPage.route;
          }
          return null;

        case AuthStatus.authenticated:
          if (isAuthRoute || state.uri.path == LandingPage.route) {
            return AnalysesOverviewPage.route;
          }
          return null;

        case AuthStatus.mfaRequired:
        case AuthStatus.error:
        case AuthStatus.loading:
          return null;
      }
    },
  );
}
