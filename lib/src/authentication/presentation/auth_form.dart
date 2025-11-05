import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';
import 'package:larvixon_frontend/src/common/widgets/larvixon_logo.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/form_validators_mixin.dart';
import 'package:larvixon_frontend/src/common/mixins/field_error_mixin.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_error_dialog.dart';

enum AuthFormMode { signUp, signIn }

class AuthForm extends StatefulWidget {
  final AuthFormMode initialMode;
  final String? initialEmail;
  const AuthForm({super.key, required this.initialMode, this.initialEmail});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        FormValidatorsMixin,
        FieldErrorMixin<AuthForm>,
        FormFieldValidationMixin<AuthForm> {
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

    _emailController.addListener(() => onFieldChanged('email'));
    _passwordController.addListener(() => onFieldChanged('password'));
    _confirmPasswordController.addListener(
      () => onFieldChanged('confirm_password'),
    );
    _usernameController.addListener(() => onFieldChanged('username'));
    _firstNameController.addListener(() => onFieldChanged('first_name'));
    _lastNameController.addListener(() => onFieldChanged('last_name'));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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

                if (_hasErrors(state)) {
                  final error = state.error!;
                  if (error is ValidationFailure &&
                      error.fieldErrors.isNotEmpty) {
                    setFieldErrors(error.fieldErrors);
                    _formKey.currentState?.validate();
                  } else {
                    AuthErrorDialog.show(
                      context,
                      error: error,
                      onRetry: _submitForm,
                      onMfaRequired: _showMfaDialog,
                    );
                  }
                } else if (_hasMfaError(state)) {
                  _showMfaDialog();
                } else if (state.status != AuthStatus.error &&
                    fieldErrors.isNotEmpty) {
                  clearAllErrors();
                }
              },
              child: AnimatedLogo(logoController: _logoController),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                _buildModeButton(context, AuthFormMode.signIn),
                _buildModeButton(context, AuthFormMode.signUp),
              ],
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(hintText: context.translate.email),
              autofillHints: const [AutofillHints.email],
              autovalidateMode: getAutovalidateMode('email'),
              validator: (value) => validateField(
                context,
                'email',
                (context, value) => emailValidator(context, value),
                value,
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: context.translate.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              autofillHints: const [AutofillHints.password],
              autovalidateMode: getAutovalidateMode('password'),
              validator: (value) => validateField(
                context,
                'password',
                (context, value) => passwordValidator(
                  context,
                  value,
                  onlyCheckEmpty: _formMode == AuthFormMode.signIn,
                ),
                value,
              ),
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
                        Column(
                          spacing: 6.0,
                          children: [
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: context.translate.confirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                ),
                              ),
                              obscureText: _obscureConfirmPassword,
                              autovalidateMode: getAutovalidateMode(
                                'confirm_password',
                              ),
                              validator: (value) => validateField(
                                context,
                                'confirm_password',
                                (context, value) => confirmPasswordValidator(
                                  context,
                                  _passwordController.text,
                                  value,
                                ),
                                value,
                              ),
                            ),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: context.translate.username,
                              ),
                              autovalidateMode: getAutovalidateMode('username'),
                              validator: (value) => validateField(
                                context,
                                'username',
                                (context, value) =>
                                    usernameValidator(context, value),
                                value,
                              ),
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                hintText: context.translate.firstName,
                              ),
                              autovalidateMode: getAutovalidateMode(
                                'first_name',
                              ),
                              validator: (value) => validateField(
                                context,
                                'first_name',
                                (context, value) =>
                                    firstNameValidator(context, value),
                                value,
                              ),
                            ),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                hintText: context.translate.lastName,
                              ),
                              autovalidateMode: getAutovalidateMode(
                                'last_name',
                              ),
                              validator: (value) => validateField(
                                context,
                                'last_name',
                                (context, value) =>
                                    lastNameValidator(context, value),
                                value,
                              ),
                            ),
                          ],
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
                child: IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  key: ValueKey(_formMode),
                  onPressed: _submitForm,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasMfaError(AuthState state) {
    return state.status == AuthStatus.mfaRequired && state.error != null;
  }

  bool _hasErrors(AuthState state) =>
      state.status == AuthStatus.error && state.error != null;

  Widget _buildModeButton(BuildContext context, AuthFormMode mode) {
    final selected = _formMode == mode;
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() {
          _formMode = mode;
          clearAllErrors();
        }),
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? colors.primary
              : colors.surfaceContainerHighest,
          foregroundColor: selected
              ? colors.onPrimary
              : colors.onSurfaceVariant,
        ),
        child: Text(
          mode == AuthFormMode.signIn
              ? context.translate.signIn
              : context.translate.signUp,
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
    } else {
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
  }

  void _showMfaDialog() {
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

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key, required AnimationController logoController})
    : _logoController = logoController;

  final AnimationController _logoController;

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    return AnimatedBuilder(
      animation: _logoController,
      child: const LarvixonLogo(useFull: false),
      builder: (context, child) => Transform.scale(
        scale: scaleAnimation.value,
        child: Center(child: child),
      ),
    );
  }
}
