import 'package:flutter/material.dart';

import '../../landing/landing_page.dart';
import 'auth_form.dart';

class AuthPage extends StatefulWidget {
  static const String route = '/login';
  static const String name = 'login';
  final AuthFormMode initialMode;
  final String? initialEmail;

  const AuthPage({
    super.key,
    this.initialMode = AuthFormMode.signUp,
    this.initialEmail,
  });

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
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Background(),
              Row(
                children: [
                  if (isWide) Expanded(flex: 3, child: Placeholder()),
                  Flexible(
                    flex: isWide ? 2 : 1,
                    child: AuthForm(
                      initialMode: widget.initialMode,
                      initialEmail: widget.initialEmail,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
