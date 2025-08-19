import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/authentication/presentation/signin_form.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';

import '../bloc/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  static const String route = '/login';
  static const String name = 'login';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: isWide
          ? Row(
              children: [
                Flexible(flex: 3, child: Placeholder()),
                Flexible(flex: 2, child: Center(child: AuthForm())),
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AuthForm(),
              ),
            ),
    );
  }
}
