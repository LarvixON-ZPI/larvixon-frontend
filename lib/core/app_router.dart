import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/transitions.dart';
import 'package:larvixon_frontend/src/analysis/domain/larva_video_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/larva_video_details_page.dart';
import 'package:larvixon_frontend/src/analysis/video_bloc/larva_video_bloc.dart';
import 'package:larvixon_frontend/src/analysis/video_list_cubit/larva_video_list_cubit.dart';
import 'package:larvixon_frontend/src/landing/presentation/about/about_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact/contact_page.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing_scaffold.dart';

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

  late final router = GoRouter(
    initialLocation: LandingPage.route,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    routes: [
      ShellRoute(
        navigatorKey: _landingShellNavigatorKey,
        pageBuilder: (context, state, child) {
          return LandingScaffold(child: child).withSlideTransition(state);
        },

        routes: [
          GoRoute(
            name: LandingPage.name,
            path: LandingPage.route,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};

              return const LandingPage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            name: ContactPage.name,
            path: ContactPage.route,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return const ContactPage().withoutTransition(state: state);
            },
          ),
          GoRoute(
            name: AboutPage.name,
            path: AboutPage.route,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
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

      GoRoute(
        path: HomePage.route,
        name: HomePage.name,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              LarvaVideoListCubit(context.read<LarvaVideoRepository>())
                ..fetchVideoList(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AccountPage.route,
        name: AccountPage.name,
        builder: (_, _) => const AccountPage(),
      ),
      GoRoute(
        path: LarvaVideoDetailsPage.routeName,
        name: LarvaVideoDetailsPage.name,
        redirect: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final videoBloc = extra['bloc'] as LarvaVideoBloc?;
          final videoId = extra['videoId'] as int?;
          if (videoBloc == null && videoId == null) {
            return HomePage.route;
          }
          return null;
        },
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final videoBloc = extra['bloc'] as LarvaVideoBloc?;
          if (videoBloc is LarvaVideoBloc) {
            return BlocProvider.value(
              value: videoBloc,
              child: LarvaVideoDetailsPage(),
            );
          }
          final videoId = extra['videoId'] as int?;
          if (videoId is int) {
            return BlocProvider<LarvaVideoBloc>(
              create: (context) => LarvaVideoBloc(
                repository: context.read<LarvaVideoRepository>(),
              )..add(FetchLarvaVideoDetails(videoId: videoId)),
              child: LarvaVideoDetailsPage(),
            );
          }
          return const SizedBox.shrink();
        },
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
          if (loggingIn || onLanding) return HomePage.route;
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
