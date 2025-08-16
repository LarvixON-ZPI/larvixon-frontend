import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/src/authentication/auth_repository.dart';
import 'package:larvixon_frontend/src/home/home_page.dart';

import 'core/token_storage.dart';
import 'src/authentication/auth_datasource.dart';
import 'src/authentication/bloc/auth_bloc.dart';
import 'src/authentication/presentation/auth_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement better DI
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
        child: MaterialApp(
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              switch (state.status) {
                case AuthStatus.authenticated:
                  return const HomePage();
                case AuthStatus.unauthenticated:
                case AuthStatus.initial:
                case AuthStatus.error:
                default:
                  return const AuthPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
