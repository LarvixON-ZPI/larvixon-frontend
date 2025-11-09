import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';

import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';

class AuthErrorDialog extends StatelessWidget {
  final Failure error;
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
      InvalidCredentialsFailure() => context.translate.signInFailed,
      DisabledAccountFailure() => context.translate.accountDisabled,
      MfaRequiredButNoCodeFailure() => context.translate.mfaRequired,
      MfaFailure() => context.translate.authenticationError,
      ValidationFailure() => context.translate.validationError,
      RequestTimeoutFailure() => context.translate.connectionError,
      InternalServerErrorFailure() => context.translate.serverError,
      _ => context.translate.error,
    };
  }

  String _getErrorMessage(BuildContext context) {
    return switch (error) {
      InvalidCredentialsFailure() =>
        context.translate.invalidCredentialsMessage,
      DisabledAccountFailure() => context.translate.accountDisabledMessage,
      MfaRequiredButNoCodeFailure() => context.translate.mfaRequiredMessage,
      MfaDeviceNotFoundFailure() => context.translate.mfaDeviceNotFoundMessage,
      MfaDeviceNotConfirmedFailure() =>
        context.translate.mfaDeviceNotConfirmedMessage,
      MfaSecretMissingFailure() => context.translate.mfaSecretMissingMessage,
      InvalidMfaCodeFailure() => context.translate.invalidMfaCodeMessage,
      ValidationFailure(:final fieldErrors) => _buildFieldErrorMessage(
        context,
        fieldErrors,
      ),
      RequestTimeoutFailure() => context.translate.networkErrorMessage,
      ServiceUnavailableFailure() => context.translate.serverErrorMessage,
      _ => error.message,
    };
  }

  String _buildFieldErrorMessage(
    BuildContext context,
    Map<String, String> fieldErrors,
  ) {
    final buffer = StringBuffer();

    for (final entry in fieldErrors.entries) {
      final field = _translateFieldName(context, entry.key);
      final errors = entry.value;

      if (errors.isNotEmpty) {
        buffer.writeln('$field: $error');
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
    if (error is MfaRequiredButNoCodeFailure && onMfaRequired != null) {
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
      child: Text(context.translate.enterMfaCode),
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
      child: Text(context.translate.tryAgain),
    );
  }

  bool _isRetriableError() {
    return switch (error) {
      RequestTimeoutFailure() => true,
      ServiceUnavailableFailure() => true,
      InvalidMfaCodeFailure() => true,
      _ => false,
    };
  }

  static Future<void> show(
    BuildContext context, {
    required Failure error,
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
