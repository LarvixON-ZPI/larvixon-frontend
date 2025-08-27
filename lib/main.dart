import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api_client.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/token_storage.dart';
import 'l10n/app_localizations.dart';
import 'src/authentication/data/auth_datasource.dart';
import 'src/authentication/domain/auth_repository.dart';
import 'src/authentication/domain/auth_repository_impl.dart';
import 'src/authentication/bloc/auth_bloc.dart';
import 'src/user/bloc/user_bloc.dart';
import 'src/user/data/user_datasource.dart';
import 'src/user/domain/user_repository.dart';
import 'src/user/domain/user_repository_impl.dart';

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
  late final TokenStorage _tokenStorage;
  late final ApiClient _apiClient;
  late final AuthDataSource _authDataSource;
  late final UserDataSource _userDataSource;

  @override
  void initState() {
    super.initState();
    _tokenStorage = TokenStorage();
    _apiClient = ApiClient(_tokenStorage);
    _authDataSource = AuthDataSource(_apiClient);
    _userDataSource = UserDataSource(_apiClient);
    _authRepository = AuthRepositoryImpl(
      dataSource: _authDataSource,
      tokenStorage: _tokenStorage,
    );
    _userRepository = UserRepositoryImpl(dataSource: _userDataSource);
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

  MultiRepositoryProvider _buildRepositoryProviders() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenStorage>.value(value: _tokenStorage),
        RepositoryProvider<ApiClient>.value(value: _apiClient),
        RepositoryProvider<AuthDataSource>.value(value: _authDataSource),
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<UserDataSource>.value(value: _userDataSource),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
      ],
      child: _buildBlocProviders(),
    );
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
          theme: appTheme,
          routerConfig: _appRouter.router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRepositoryProviders();
  }
}
