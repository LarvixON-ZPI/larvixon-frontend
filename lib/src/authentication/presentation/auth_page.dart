import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return Scaffold(
          body: Row(
            children: [
              if (isWide) Expanded(flex: 3, child: Placeholder()),
              Flexible(flex: isWide ? 2 : 1, child: AuthForm()),
            ],
          ),
        );
      },
    );
  }
}
