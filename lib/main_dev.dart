import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'src/authentication/domain/auth_repository.dart';
import 'src/authentication/bloc/auth_bloc.dart';
import 'src/authentication/domain/auth_repository_fake.dart';
import 'src/user/bloc/user_bloc.dart';
import 'src/user/domain/user_repository.dart';
import 'src/user/domain/user_repository_fake.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppRouter _appRouter;
  late final AuthBloc _authBloc;
  late final UserBloc _userBloc;
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryFake();
    _userRepository = UserRepositoryFake();
    _authBloc = AuthBloc(_authRepository)..add(AuthVerificationRequested());
    _userBloc = UserBloc(_userRepository);
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _userBloc.close();
    super.dispose();
  }

  MultiBlocProvider _buildBlocProviders() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<UserBloc>.value(value: _userBloc),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            context.read<UserBloc>().add(UserProfileClearRequested());
          } else if (state.status == AuthStatus.authenticated) {
            context.read<UserBloc>().add(UserProfileDataRequested());
          }
        },
        child: MaterialApp.router(
          theme: appThemeLight,
          routerConfig: _appRouter.router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  MultiRepositoryProvider _buildRepositoryProvider() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
      ],
      child: _buildBlocProviders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRepositoryProvider();
  }
}
