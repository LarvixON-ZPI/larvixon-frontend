import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

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
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: CustomCard(
              children: [
                AuthForm(
                  initialMode: widget.initialMode,
                  initialEmail: widget.initialEmail,
                ),
              ],
            ).withDefaultPagePadding,
          ),
        ),
      ),
    );
  }
}
