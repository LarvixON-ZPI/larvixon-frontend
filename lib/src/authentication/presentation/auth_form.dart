import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/extensions/translate_extension.dart';
import '../../common/form_validators.dart';
import '../bloc/auth_bloc.dart';
import '../domain/auth_error.dart';
import 'auth_error_dialog.dart';

enum AuthFormMode { signUp, signIn }

class AuthForm extends StatefulWidget {
  final AuthFormMode initialMode;
  final String? initialEmail;
  const AuthForm({super.key, required this.initialMode, this.initialEmail});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AuthFormMode _formMode;
  late final AnimationController _logoController;
  late final Animation<double> _scaleAnimation;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Map<String, String> _serverSideFieldErrors = {};

  // Track which fields have been validated (to enable continuous validation)
  Set<String> _validatedFields = {};

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formMode = widget.initialMode;
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _emailController.addListener(() => _onFieldChanged('email'));
    _passwordController.addListener(() => _onFieldChanged('password'));
    _confirmPasswordController.addListener(
      () => _onFieldChanged('confirm_password'),
    );
    _usernameController.addListener(() => _onFieldChanged('username'));
    _firstNameController.addListener(() => _onFieldChanged('first_name'));
    _lastNameController.addListener(() => _onFieldChanged('last_name'));
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
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.loading) {
                  _logoController.repeat(reverse: true);
                } else {
                  _logoController.stop();
                  _logoController.value = 0.0;
                }

                if (state.status == AuthStatus.error && state.error != null) {
                  if (state.error is FieldValidationError) {
                    final fieldError = state.error as FieldValidationError;
                    setState(() {
                      _serverSideFieldErrors = {};
                      for (final entry in fieldError.fieldErrors.entries) {
                        if (entry.value.isNotEmpty) {
                          _serverSideFieldErrors[entry.key] = entry.value.first;
                        }
                      }
                    });

                    _formKey.currentState?.validate();
                  } else {
                    AuthErrorDialog.show(
                      context,
                      error: state.error!,
                      onRetry: () => _submitForm(),
                      onMfaRequired: () => _showMfaDialog(),
                    );
                  }
                } else if (state.status == AuthStatus.mfaRequired &&
                    state.error != null) {
                  _showMfaDialog();
                }

                if (state.status != AuthStatus.error &&
                    _serverSideFieldErrors.isNotEmpty) {
                  setState(() {
                    _serverSideFieldErrors = {};
                  });
                }
              },
              child: AnimatedBuilder(
                animation: _logoController,
                child: Text(
                  context.translate.larvixon,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Center(child: child),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
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

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(hintText: context.translate.email),
              autofillHints: [AutofillHints.email],
              autovalidateMode:
                  (_validatedFields.contains('email') ||
                      _serverSideFieldErrors.containsKey('email'))
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (_serverSideFieldErrors['email'] != null) {
                  return _serverSideFieldErrors['email'];
                }
                if (_validatedFields.contains('email')) {
                  return FormValidators.emailValidator(context, value);
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              autofillHints: [AutofillHints.password],
              decoration: InputDecoration(
                hintText: context.translate.password,
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
              autovalidateMode:
                  (_validatedFields.contains('password') ||
                      _serverSideFieldErrors.containsKey('password'))
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (_serverSideFieldErrors['password'] != null) {
                  return _serverSideFieldErrors['password'];
                }
                if (_validatedFields.contains('password')) {
                  return FormValidators.passwordValidator(
                    context,
                    value,
                    onlyCheckEmpty: _formMode == AuthFormMode.signIn,
                  );
                }
                return null;
              },
              onFieldSubmitted: _formMode == AuthFormMode.signIn
                  ? (_) => _submitForm()
                  : null,
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
                          decoration: InputDecoration(
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
                          autovalidateMode:
                              _validatedFields.contains('confirm_password')
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            if (_validatedFields.contains('confirm_password')) {
                              return FormValidators.confirmPasswordValidator(
                                context,
                                _passwordController.text,
                                value,
                              );
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _usernameController,
                          autofillHints: [AutofillHints.username],
                          decoration: InputDecoration(
                            hintText: context.translate.username,
                          ),
                          autovalidateMode:
                              _validatedFields.contains('username')
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            if (_serverSideFieldErrors['username'] != null) {
                              return _serverSideFieldErrors['username'];
                            }
                            if (_validatedFields.contains('username')) {
                              return FormValidators.usernameValidator(
                                context,
                                value,
                              );
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _firstNameController,
                          autofillHints: [AutofillHints.givenName],
                          decoration: InputDecoration(
                            hintText: context.translate.firstName,
                          ),
                          autovalidateMode:
                              _validatedFields.contains('first_name')
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            if (_serverSideFieldErrors['first_name'] != null) {
                              return _serverSideFieldErrors['first_name'];
                            }
                            if (_validatedFields.contains('first_name')) {
                              return FormValidators.firstNameValidator(
                                context,
                                value,
                              );
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          autofillHints: [AutofillHints.familyName],
                          decoration: InputDecoration(
                            hintText: context.translate.lastName,
                          ),
                          autovalidateMode:
                              _validatedFields.contains('last_name')
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            if (_serverSideFieldErrors['last_name'] != null) {
                              return _serverSideFieldErrors['last_name'];
                            }
                            if (_validatedFields.contains('last_name')) {
                              return FormValidators.lastNameValidator(
                                context,
                                value,
                              );
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: ElevatedButton(
                  key: ValueKey(_formMode),
                  onPressed: _submitForm,
                  child: Text(
                    _formMode == AuthFormMode.signIn
                        ? context.translate.signIn
                        : context.translate.signUp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    _validatedFields.addAll(['email', 'password']);
    if (_formMode == AuthFormMode.signUp) {
      _validatedFields.addAll([
        'username',
        'first_name',
        'last_name',
        'confirm_password',
      ]);
    }

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

  void _onFieldChanged(String fieldName) {
    bool serverErrorCleared = false;
    if (_serverSideFieldErrors.containsKey(fieldName)) {
      _serverSideFieldErrors.remove(fieldName);
      serverErrorCleared = true;
    }

    if (_validatedFields.contains(fieldName) || serverErrorCleared) {
      setState(() {
        // This setState will cause the form to rebuild and re-run validators
      });
    }
  }

  void _showMfaDialog() {
    // TODO: Implement MFA dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.translate.mfaDialogTitle),
        content: Text(context.translate.mfaNotImplemented),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.translate.cancel),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
