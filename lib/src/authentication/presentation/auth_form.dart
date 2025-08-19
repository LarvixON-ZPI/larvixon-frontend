import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '/extensions/translate_extension.dart';
import 'auth_form_validators.dart';

enum AuthFormMode { signUp, signIn }

class AuthForm extends StatefulWidget {
  static const String tab = 'signup';
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  AuthFormMode _formMode = AuthFormMode.signUp;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _formMode = AuthFormMode.signIn);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _formMode == AuthFormMode.signIn
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                    ),
                    child: Text(
                      context.translate.signIn,
                      style: TextStyle(
                        color: _formMode == AuthFormMode.signIn
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _formMode = AuthFormMode.signUp);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _formMode == AuthFormMode.signUp
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                    ),
                    child: Text(
                      context.translate.signUp,
                      style: TextStyle(
                        color: _formMode == AuthFormMode.signUp
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: context.translate.email),
              autofillHints: [AutofillHints.email],
              validator: (value) =>
                  AuthFormValidators.emailValidator(context, value),
            ),
            TextFormField(
              controller: _passwordController,
              autofillHints: [AutofillHints.password],
              decoration: InputDecoration(
                labelText: context.translate.password,
              ),
              obscureText: true,
              validator: (value) => AuthFormValidators.passwordValidator(
                context,
                value,
                onlyCheckEmpty: _formMode == AuthFormMode.signIn,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),

              child: _formMode == AuthFormMode.signUp
                  ? TextFormField(
                      controller: _confirmPasswordController,
                      autofillHints: [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: context.translate.confirmPassword,
                      ),
                      obscureText: true,
                      validator: (value) =>
                          AuthFormValidators.confirmPasswordValidator(
                            context,
                            _passwordController.text,
                            value,
                          ),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: _formMode == AuthFormMode.signUp
                  ? TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: context.translate.username,
                      ),
                      autofillHints: [AutofillHints.username],
                      validator: (value) =>
                          AuthFormValidators.usernameValidator(context, value),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: _formMode == AuthFormMode.signUp
                  ? TextFormField(
                      controller: _firstNameController,
                      autofillHints: [AutofillHints.givenName],
                      decoration: InputDecoration(
                        labelText: context.translate.firstName,
                      ),
                      validator: (value) =>
                          AuthFormValidators.firstNameValidator(context, value),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 750),
              child: _formMode == AuthFormMode.signUp
                  ? TextFormField(
                      controller: _lastNameController,
                      autofillHints: [AutofillHints.familyName],
                      decoration: InputDecoration(
                        labelText: context.translate.lastName,
                      ),
                      validator: (value) =>
                          AuthFormValidators.lastNameValidator(context, value),
                    )
                  : SizedBox.shrink(),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                _formMode == AuthFormMode.signIn
                    ? context.translate.signIn
                    : context.translate.signUp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_formMode == AuthFormMode.signIn) {
      context.read<AuthBloc>().add(
        AuthSignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
