import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '/extensions/translate_extension.dart';
import 'auth_form_validators.dart';
import 'package:flutter/widget_previews.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.0,
          children: [
            Text("Larvixon", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16.0),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: const SizedBox(height: 2, width: double.infinity),
            ),
            const SizedBox(height: 16.0),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _formMode = AuthFormMode.signIn);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
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
                      minimumSize: const Size(double.infinity, 48),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
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

            TextFormField(
              controller: _emailController,
              decoration: _buildInputDecoration(
                hintText: context.translate.email,
                prefixIcon: Icons.email,
              ),
              autofillHints: [AutofillHints.email],
              validator: (value) =>
                  AuthFormValidators.emailValidator(context, value),
            ),
            TextFormField(
              controller: _passwordController,
              autofillHints: [AutofillHints.password],
              decoration: _buildInputDecoration(
                hintText: context.translate.password,
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              obscureText: _obscurePassword,
              validator: (value) => AuthFormValidators.passwordValidator(
                context,
                value,
                onlyCheckEmpty: _formMode == AuthFormMode.signIn,
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 600),
              curve: Curves.ease,
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    spacing: 6.0,
                    children: [
                      if (_formMode == AuthFormMode.signUp) ...[
                        TextFormField(
                          controller: _confirmPasswordController,
                          autofillHints: [AutofillHints.password],
                          decoration: _buildInputDecoration(
                            hintText: context.translate.confirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[700],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) =>
                              AuthFormValidators.confirmPasswordValidator(
                                context,
                                _passwordController.text,
                                value,
                              ),
                        ),
                        TextFormField(
                          controller: _usernameController,
                          autofillHints: [AutofillHints.username],
                          decoration: _buildInputDecoration(
                            hintText: context.translate.username,
                            prefixIcon: Icons.person,
                          ),
                          validator: (value) =>
                              AuthFormValidators.usernameValidator(
                                context,
                                value,
                              ),
                        ),
                        TextFormField(
                          controller: _firstNameController,
                          autofillHints: [AutofillHints.givenName],
                          decoration: _buildInputDecoration(
                            hintText: context.translate.firstName,
                          ),
                          validator: (value) =>
                              AuthFormValidators.firstNameValidator(
                                context,
                                value,
                              ),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          autofillHints: [AutofillHints.familyName],
                          decoration: _buildInputDecoration(
                            hintText: context.translate.lastName,
                          ),
                          validator: (value) =>
                              AuthFormValidators.lastNameValidator(
                                context,
                                value,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.grey[300],
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              key: ValueKey(_formMode),
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

  InputDecoration _buildInputDecoration({
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      fillColor: Colors.grey[200],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey[700])
          : null,
      suffixIcon: suffixIcon,
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
