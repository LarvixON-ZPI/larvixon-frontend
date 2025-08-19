import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/api_client.dart';
import 'core/app_router.dart';
import 'core/token_storage.dart';
import 'l10n/app_localizations.dart';
import 'src/authentication/auth_datasource.dart';
import 'src/authentication/auth_repository.dart';
import 'src/authentication/bloc/auth_bloc.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<AuthRepository>())
                  ..add(AuthVerificationRequested()),
          ),
        ],
        child: Builder(
          builder: (context) {
            final authBloc = context.read<AuthBloc>();
            final appRouter = AppRouter(authBloc);
            return MaterialApp.router(
              routerConfig: appRouter.router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
