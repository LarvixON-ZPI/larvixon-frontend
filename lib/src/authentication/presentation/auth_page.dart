import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish.dart';
import 'package:larvixon_frontend/src/landing/presentation/background.dart';

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
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Background(),
              Positioned.fill(child: PetriDish(larvaeCount: 6)),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: CustomCard(
                      children: [
                        AuthForm(
                          initialMode: widget.initialMode,
                          initialEmail: widget.initialEmail,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
