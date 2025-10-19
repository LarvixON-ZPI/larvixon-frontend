import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/transitions.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analysis_details_page.dart';
import 'package:larvixon_frontend/src/home/larvixon_app_bar.dart';
import 'package:larvixon_frontend/src/about_us/presentation/pages/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing_appbar.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/common/app_shell.dart';
import 'package:larvixon_frontend/src/settings/presentation/pages/settings_page.dart';

import '../src/authentication/bloc/auth_bloc.dart';
import '../src/authentication/presentation/auth_form.dart';
import '../src/authentication/presentation/auth_page.dart';
import '../src/home/home_page.dart';
import '../src/landing/presentation/landing/landing_page.dart';
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
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'Root',
  );
  final GlobalKey<NavigatorState> _landingShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'LandingShell');
  final GlobalKey<NavigatorState> _appShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'AppShell');

  late final router = GoRouter(
    initialLocation: LandingPage.route,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    routes: [
      ShellRoute(
        navigatorKey: _landingShellNavigatorKey,
        pageBuilder: (context, state, child) {
          return AppShell(
            appBar: const LandingAppBar(),
            child: child,
          ).withSlideTransition(state);
        },

        routes: [
          GoRoute(
            name: LandingPage.name,
            path: LandingPage.route,
            pageBuilder: (context, state) {
              return const LandingPage().withoutTransition(state: state);
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
        ],
      ),

      ShellRoute(
        navigatorKey: _appShellNavigatorKey,
        pageBuilder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    AnalysisListCubit(context.read())..fetchVideoList(),
              ),
            ],
            child: AppShell(appBar: const LarvixonAppBar(), child: child),
          ).withSlideTransition(state);
        },

        routes: [
          GoRoute(
            path: HomePage.route,
            name: HomePage.name,
            pageBuilder: (context, state) {
              return const HomePage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            path: AnalysesPage.route,
            name: AnalysesPage.name,
            pageBuilder: (context, state) {
              return const AnalysesPage().withoutTransition(state: state);
            },
            routes: [
              GoRoute(
                path: AnalysisDetailsPage.route,
                name: AnalysisDetailsPage.name,
                redirect: (context, state) {
                  final analysisId = state.pathParameters['analysisId'];
                  if (analysisId == null) {
                    return HomePage.route;
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
              return SettingsPage().withoutTransition(state: state);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final loggingIn = state.uri.path == AuthPage.route;
      final onLanding = state.uri.path == LandingPage.route;
      final onAbout = state.uri.path == AboutPage.route;
      final onContact = state.uri.path == ContactPage.route;

      switch (authState.status) {
        case AuthStatus.initial:
        case AuthStatus.unauthenticated:
          if (!loggingIn && !onLanding && !onAbout && !onContact) {
            return LandingPage.route;
          }
          return null;
        case AuthStatus.authenticated:
          if (loggingIn || onLanding) return AnalysesPage.route;
          return null;
        case AuthStatus.mfaRequired:
        case AuthStatus.error:
        case AuthStatus.loading:
          return null;
      }
    },
  );

  Page<T> buildPageWithDefaultTransition<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        );

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
