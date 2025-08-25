import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/api_client.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/token_storage.dart';
import 'l10n/app_localizations.dart';
import 'src/authentication/auth_datasource.dart';
import 'src/authentication/auth_repository.dart';
import 'src/authentication/bloc/auth_bloc.dart';
import 'src/profile/bloc/user_bloc.dart';
import 'src/profile/user_datasource.dart';
import 'src/profile/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenStorage>(create: (_) => TokenStorage()),
        RepositoryProvider<ApiClient>(
          create: (context) => ApiClient(context.read<TokenStorage>()),
        ),
        RepositoryProvider<AuthDataSource>(
          create: (context) => AuthDataSource(context.read<ApiClient>()),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            dataSource: context.read<AuthDataSource>(),
            tokenStorage: context.read<TokenStorage>(),
          ),
        ),
        RepositoryProvider<UserDataSource>(
          create: (context) => UserDataSource(context.read<ApiClient>()),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) =>
              UserRepository(dataSource: context.read<UserDataSource>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<AuthRepository>())
                  ..add(AuthVerificationRequested()),
          ),
          BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>()),
          ),
        ],
        child: Builder(
          builder: (context) {
            final appRouter = AppRouter(context.read<AuthBloc>());
            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.unauthenticated) {
                  context.read<UserBloc>().add(UserProfileClearRequested());
                } else if (state.status == AuthStatus.authenticated) {
                  context.read<UserBloc>().add(UserProfileDataRequested());
                }
              },
              child: MaterialApp.router(
                theme: appTheme,
                routerConfig: appRouter.router,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
