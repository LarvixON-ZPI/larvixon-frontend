import 'package:dio/dio.dart';

sealed class AuthError {
  final String message;

  const AuthError(this.message);

  factory AuthError.fromDioException(DioException exception) {
    final response = exception.response;

    if (response == null) {
      return const NetworkError('Network connection failed');
    }

    final data = response.data;
    final statusCode = response.statusCode;

    switch (statusCode) {
      case 202:
        if (data is Map<String, dynamic> &&
            data['detail'] == 'MFA is required.') {
          return const MfaRequiredButNoCodeError();
        }
        return const UnknownError('Unexpected response from server');

      case 400:
        if (data is Map<String, dynamic>) {
          return _parseValidationErrors(data);
        }
        return const ValidationError('Invalid request');

      case 401:
        return const AuthenticationError('Unauthorized access');

      case 403:
        return const AuthenticationError('Access forbidden');

      case 500:
        return const ServerError('Internal server error');

      default:
        return UnknownError('HTTP $statusCode: ${exception.message}');
    }
  }

  static AuthError _parseValidationErrors(Map<String, dynamic> data) {
    if (data.containsKey('non_field_errors')) {
      final errors = data['non_field_errors'] as List;
      final errorMessage = errors.isNotEmpty
          ? errors.first.toString()
          : 'Authentication failed';

      if (errorMessage.contains('Invalid email or password')) {
        return const InvalidCredentialsError();
      } else if (errorMessage.contains('Account is disabled')) {
        return const DisabledAccountError();
      } else if (errorMessage.contains('Must include email and password')) {
        return const MissingCredentialsError();
      }

      return AuthenticationError(errorMessage);
    }

    if (data.containsKey('detail')) {
      final detail = data['detail'].toString();

      if (detail == 'MFA device not found.') {
        return const MfaDeviceNotFoundError();
      } else if (detail == 'MFA device is not confirmed.') {
        return const MfaDeviceNotConfirmedError();
      } else if (detail == 'MFA secret key not found.') {
        return const MfaSecretMissingError();
      } else if (detail == 'Invalid MFA code.') {
        return const InvalidMfaCodeError();
      }

      return GenericMfaError(detail);
    }

    final fieldErrors = <String, List<String>>{};
    for (final entry in data.entries) {
      if (entry.value is List) {
        fieldErrors[entry.key] = (entry.value as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    if (fieldErrors.isNotEmpty) {
      return FieldValidationError(fieldErrors);
    }

    return const ValidationError('Validation failed');
  }
}

class NetworkError extends AuthError {
  const NetworkError(super.message);
}

class ServerError extends AuthError {
  const ServerError(super.message);
}

class AuthenticationError extends AuthError {
  const AuthenticationError(super.message);
}

class InvalidCredentialsError extends AuthError {
  const InvalidCredentialsError() : super('Invalid email or password');
}

class DisabledAccountError extends AuthError {
  const DisabledAccountError() : super('Account is disabled');
}

class MissingCredentialsError extends AuthError {
  const MissingCredentialsError() : super('Email and password are required');
}

class FieldValidationError extends AuthError {
  final Map<String, List<String>> fieldErrors;

  const FieldValidationError(this.fieldErrors)
    : super('Validation errors occurred');

  String? getFieldError(String fieldName) {
    final errors = fieldErrors[fieldName];
    return errors?.isNotEmpty == true ? errors!.first : null;
  }

  bool hasFieldError(String fieldName) {
    return fieldErrors.containsKey(fieldName) &&
        fieldErrors[fieldName]!.isNotEmpty;
  }
}

class ValidationError extends AuthError {
  const ValidationError(super.message);
}

sealed class MfaError extends AuthError {
  const MfaError(super.message);
}

class MfaRequiredButNoCodeError extends MfaError {
  const MfaRequiredButNoCodeError()
    : super('Multi-factor authentication is required');
}

class MfaDeviceNotFoundError extends MfaError {
  const MfaDeviceNotFoundError() : super('MFA device not found');
}

class MfaDeviceNotConfirmedError extends MfaError {
  const MfaDeviceNotConfirmedError() : super('MFA device is not confirmed');
}

class MfaSecretMissingError extends MfaError {
  const MfaSecretMissingError() : super('MFA secret key not found');
}

class InvalidMfaCodeError extends MfaError {
  const InvalidMfaCodeError() : super('Invalid MFA code');
}

class GenericMfaError extends MfaError {
  const GenericMfaError(super.message);
}

class UnknownError extends AuthError {
  const UnknownError(super.message);
}
