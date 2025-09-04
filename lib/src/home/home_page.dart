import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/user/presentation/account_page.dart';
import '../authentication/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String route = '/home';
  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push(AccountPage.route);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('You are logged in!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
