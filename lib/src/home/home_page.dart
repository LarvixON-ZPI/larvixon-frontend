import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/presentation/larva_video_add_dialog.dart';
import 'package:larvixon_frontend/src/analysis/presentation/video_grid.dart';
import 'package:larvixon_frontend/src/analysis/video_list_cubit/larva_video_list_cubit.dart';
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
            onPressed: () async {
              await LarvaVideoAddForm.showLarvaVideoDialog(
                context,
                context.read<LarvaVideoListCubit>(),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go(AccountPage.route);
            },
          ),
        ],
      ),
      body: const LarvaVideoGrid(),
    );
  }
}
