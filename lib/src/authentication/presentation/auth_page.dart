import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/landing/presentation/background.dart';
import 'package:larvixon_frontend/src/landing/presentation/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/petri_dish/petri_dish.dart';

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
        final isWide = constraints.maxWidth > Breakpoints.large;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Background(),
              Positioned.fill(child: PetriDish(larvaeCount: 6)),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        Flexible(
                          flex: 3,
                          child: CustomCard(
                            widgets: [
                              AuthForm(
                                initialMode: widget.initialMode,
                                initialEmail: widget.initialEmail,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
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
