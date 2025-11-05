import 'package:larvixon_frontend/core/errors/api_failures.dart';

sealed class AuthFailure extends BadRequestFailure {
  const AuthFailure({required super.message});

  factory AuthFailure.fromBadRequest(BadRequestFailure failure) {
    if (failure is ValidationFailure) {
      final data = failure.responseData;
      if (data is! Map<String, dynamic>) {
        return UnknownAuthFailure(message: failure.message);
      }

      final nonFieldErrors = data['non_field_errors'] as List<dynamic>?;
      if (nonFieldErrors != null && nonFieldErrors.isNotEmpty) {
        final errorMessage = nonFieldErrors.first.toString();

        if (errorMessage.contains('Invalid email or password')) {
          return const InvalidCredentialsFailure();
        } else if (errorMessage.contains('Account is disabled')) {
          return const DisabledAccountFailure();
        } else if (errorMessage.contains('Must include email and password')) {
          return const MissingCredentialsFailure();
        }
        return UnknownAuthFailure(message: errorMessage);
      }

      final detail = data['detail']?.toString();
      if (detail != null) {
        return switch (detail) {
          'MFA device not found.' => const MfaDeviceNotFoundFailure(),
          'MFA device is not confirmed.' =>
            const MfaDeviceNotConfirmedFailure(),
          'MFA secret key not found.' => const MfaSecretMissingFailure(),
          'Invalid MFA code.' => const InvalidMfaCodeFailure(),
          _ => UnknownAuthFailure(message: detail),
        };
      }
    }

    return UnknownAuthFailure(message: failure.message);
  }
}

final class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure({required super.message});
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
    : super(message: 'Invalid email or password');
}

final class DisabledAccountFailure extends AuthFailure {
  const DisabledAccountFailure() : super(message: 'Account is disabled');
}

final class MissingCredentialsFailure extends AuthFailure {
  const MissingCredentialsFailure()
    : super(message: 'Email and password are required');
}

sealed class MfaFailure extends AuthFailure {
  const MfaFailure({required super.message});
}

final class MfaRequiredButNoCodeFailure extends MfaFailure {
  const MfaRequiredButNoCodeFailure()
    : super(message: 'Multi-factor authentication is required');
}

final class MfaDeviceNotFoundFailure extends MfaFailure {
  const MfaDeviceNotFoundFailure() : super(message: 'MFA device not found');
}

final class MfaDeviceNotConfirmedFailure extends MfaFailure {
  const MfaDeviceNotConfirmedFailure()
    : super(message: 'MFA device is not confirmed');
}

final class MfaSecretMissingFailure extends MfaFailure {
  const MfaSecretMissingFailure() : super(message: 'MFA secret key not found');
}

final class InvalidMfaCodeFailure extends MfaFailure {
  const InvalidMfaCodeFailure() : super(message: 'Invalid MFA code');
}

final class GenericMfaFailure extends MfaFailure {
  const GenericMfaFailure({required super.message});
}
