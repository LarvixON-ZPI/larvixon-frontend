import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/settings/domain/repositories/settings_repository.dart';
import 'package:larvixon_frontend/src/settings/domain/repositories/settings_repository_impl.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';

import 'package:larvixon_frontend/core/app_router.dart';
import 'package:larvixon_frontend/core/theme/app_theme.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository_fake.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository_fake.dart';
import 'package:larvixon_frontend/src/user/bloc/user_bloc.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository_fake.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
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
  late final AnalysisRepository _larvaVideoRepository;
  late final SettingsRepository _settingsRepository;
  late final SettingsCubit _settingsCubit;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryFake();
    _larvaVideoRepository = AnalysisRepositoryFake();
    _userRepository = UserRepositoryFake();
    _settingsRepository = SettingsRepositoryImpl();
    _authBloc = AuthBloc(_authRepository)..add(AuthVerificationRequested());
    _userBloc = UserBloc(_userRepository);
    _appRouter = AppRouter(_authBloc);
    _settingsCubit = SettingsCubit(
      repository: _settingsRepository,
      supportedLocales: AppLocalizations.supportedLocales,
    )..loadSettings();
  }

  @override
  void dispose() {
    _authBloc.close();
    _userBloc.close();
    _settingsCubit.close();
    _larvaVideoRepository.dispose();
    super.dispose();
  }

  MultiBlocProvider _buildBlocProviders() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<UserBloc>.value(value: _userBloc),
        BlocProvider<SettingsCubit>.value(value: _settingsCubit),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            context.read<UserBloc>().add(UserProfileClearRequested());
          } else if (state.status == AuthStatus.authenticated) {
            context.read<UserBloc>().add(UserProfileDataRequested());
          }
        },
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp.router(
              theme: AppTheme.appThemeLight,
              darkTheme: AppTheme.appThemeDark,
              themeMode: state.theme,
              locale: state.locale,
              routerConfig: _appRouter.router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }

  MultiRepositoryProvider _buildRepositoryProvider() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
        RepositoryProvider<AnalysisRepository>.value(
          value: _larvaVideoRepository,
        ),
      ],
      child: _buildBlocProviders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRepositoryProvider();
  }
}
