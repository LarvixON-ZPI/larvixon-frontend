import 'package:flutter/material.dart';

import '../../common/extensions/translate_extension.dart';
import '../domain/auth_error.dart';

class AuthErrorDialog extends StatelessWidget {
  final AuthError error;
  final VoidCallback? onRetry;
  final VoidCallback? onMfaRequired;

  const AuthErrorDialog({
    super.key,
    required this.error,
    this.onRetry,
    this.onMfaRequired,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_getErrorTitle(context)),
      content: Text(_getErrorMessage(context)),
      actions: _buildActions(context),
    );
  }

  String _getErrorTitle(BuildContext context) {
    return switch (error) {
      InvalidCredentialsError() => 'Sign In Failed',
      DisabledAccountError() => 'Account Disabled',
      MfaRequiredButNoCodeError() => 'Multi-Factor Authentication Required',
      MfaError() => 'Authentication Error',
      FieldValidationError() => 'Validation Error',
      NetworkError() => 'Connection Error',
      ServerError() => 'Server Error',
      _ => context.translate.error,
    };
  }

  String _getErrorMessage(BuildContext context) {
    return switch (error) {
      InvalidCredentialsError() =>
        'The email or password you entered is incorrect. Please try again.',

      DisabledAccountError() =>
        'Your account has been disabled. Please contact support for assistance.',

      MfaRequiredButNoCodeError() =>
        'This account requires multi-factor authentication. Please enter your authentication code.',

      MfaDeviceNotFoundError() =>
        'No multi-factor authentication device found for this account.',

      MfaDeviceNotConfirmedError() =>
        'Your multi-factor authentication device is not confirmed. Please contact support.',

      MfaSecretMissingError() =>
        'Multi-factor authentication is not properly configured. Please contact support.',

      InvalidMfaCodeError() =>
        'The authentication code you entered is invalid. Please try again.',

      FieldValidationError(:final fieldErrors) => _buildFieldErrorMessage(
        context,
        fieldErrors,
      ),

      NetworkError() =>
        'Unable to connect to the server. Please check your internet connection and try again.',

      ServerError() =>
        'The server is experiencing issues. Please try again later.',

      _ => error.message,
    };
  }

  String _buildFieldErrorMessage(
    BuildContext context,
    Map<String, List<String>> fieldErrors,
  ) {
    final buffer = StringBuffer();

    for (final entry in fieldErrors.entries) {
      final field = _translateFieldName(context, entry.key);
      final errors = entry.value;

      if (errors.isNotEmpty) {
        buffer.writeln('$field: ${errors.first}');
      }
    }

    return buffer.toString().trim();
  }

  String _translateFieldName(BuildContext context, String fieldName) {
    return switch (fieldName) {
      'email' => context.translate.email,
      'password' => context.translate.password,
      'username' => context.translate.username,
      'first_name' => context.translate.firstName,
      'last_name' => context.translate.lastName,
      _ => fieldName,
    };
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];

    actions.add(_buildCancelButton(context));

    if (error is MfaRequiredButNoCodeError && onMfaRequired != null) {
      actions.add(_buildMFAButton(context));
    } else if (_isRetriableError() && onRetry != null) {
      actions.add(_buildRetryButton(context));
    }

    return actions;
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(context.translate.cancel),
    );
  }

  Widget _buildMFAButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (onMfaRequired != null) {
          onMfaRequired!();
        }
      },
      child: const Text('Enter MFA Code'),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (onRetry != null) {
          onRetry!();
        }
      },
      child: const Text('Try Again'),
    );
  }

  bool _isRetriableError() {
    return switch (error) {
      NetworkError() => true,
      ServerError() => true,
      InvalidMfaCodeError() => true,
      _ => false,
    };
  }

  static Future<void> show(
    BuildContext context, {
    required AuthError error,
    VoidCallback? onRetry,
    VoidCallback? onMfaRequired,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthErrorDialog(
        error: error,
        onRetry: onRetry,
        onMfaRequired: onMfaRequired,
      ),
    );
  }
}
