import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/validation_failure_extensions.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';

void main() {
  group('ValidationFailure', () {
    test('should correctly identify field errors', () {
      // Arrange
      const fieldErrors = {
        'email': 'This field is required.',
        'password': 'Password is too short.',
        'username': '',
      };
      const error = ValidationFailure(
        fieldErrors: fieldErrors,
        message: 'validation_failed',
      );

      // Act & Assert
      expect(error.hasFieldError('email'), isTrue);
      expect(error.hasFieldError('password'), isTrue);
      expect(
        error.hasFieldError('username'),
        isFalse,
      ); // Empty string should return false
      expect(error.hasFieldError('nonexistent'), isFalse);
    });

    test('should return error message for a field', () {
      // Arrange
      const fieldErrors = {
        'email': 'This field is required.',
        'password': 'Password is too short.',
      };
      const error = ValidationFailure(
        fieldErrors: fieldErrors,
        message: 'validation_failed',
      );

      // Act & Assert
      expect(error.getFieldError('email'), equals('This field is required.'));
      expect(error.getFieldError('password'), equals('Password is too short.'));
      expect(error.getFieldError('nonexistent'), isNull);
    });

    test('should return null for empty error strings', () {
      // Arrange
      const fieldErrors = {'username': ''};
      const error = ValidationFailure(
        fieldErrors: fieldErrors,
        message: 'validation_failed',
      );

      // Act & Assert
      expect(error.getFieldError('username'), isNull);
      expect(error.hasFieldError('username'), isFalse);
    });

    test('should have correct error message', () {
      // Arrange
      const fieldErrors = {'email': 'This field is required.'};
      const error = ValidationFailure(
        fieldErrors: fieldErrors,
        message: 'Validation errors occurred',
      );

      // Act & Assert
      expect(error.message, equals('Validation errors occurred'));
    });
  });

  group('AuthFailure Type Hierarchy', () {
    test('should correctly identify auth failure types', () {
      const invalidCredentials = InvalidCredentialsFailure();
      const disabledAccount = DisabledAccountFailure();
      const mfaRequired = MfaRequiredButNoCodeFailure();
      const invalidMfaCode = InvalidMfaCodeFailure();

      // Test AuthFailure base type
      expect(invalidCredentials, isA<AuthFailure>());
      expect(disabledAccount, isA<AuthFailure>());
      expect(mfaRequired, isA<AuthFailure>());
      expect(invalidMfaCode, isA<AuthFailure>());

      // Test specific types
      expect(invalidCredentials, isA<InvalidCredentialsFailure>());
      expect(disabledAccount, isA<DisabledAccountFailure>());
      expect(mfaRequired, isA<MfaRequiredButNoCodeFailure>());
      expect(invalidMfaCode, isA<InvalidMfaCodeFailure>());

      // Test MFA inheritance
      expect(mfaRequired, isA<MfaFailure>());
      expect(invalidMfaCode, isA<MfaFailure>());
    });

    test('should correctly identify API failure types', () {
      const networkError = RequestTimeoutFailure(message: 'Connection failed');
      const serverError = InternalServerErrorFailure(message: 'Internal error');
      const fieldError = ValidationFailure(
        fieldErrors: {'email': 'Required'},
        message: 'Validation error',
      );

      // Test ApiFailure base type
      expect(networkError, isA<ApiFailure>());
      expect(serverError, isA<ApiFailure>());
      expect(fieldError, isA<ApiFailure>());

      // Test specific types
      expect(networkError, isA<RequestTimeoutFailure>());
      expect(serverError, isA<InternalServerErrorFailure>());
      expect(fieldError, isA<ValidationFailure>());
    });

    test('should have correct error messages', () {
      expect(
        const InvalidCredentialsFailure().message,
        equals('Invalid email or password'),
      );
      expect(
        const DisabledAccountFailure().message,
        equals('Account is disabled'),
      );
      expect(
        const MfaRequiredButNoCodeFailure().message,
        equals('Multi-factor authentication is required'),
      );
      expect(const InvalidMfaCodeFailure().message, equals('Invalid MFA code'));
      expect(
        const RequestTimeoutFailure(message: 'Connection failed').message,
        equals('Connection failed'),
      );
      expect(
        const InternalServerErrorFailure(message: 'Internal error').message,
        equals('Internal error'),
      );
      expect(
        const ValidationFailure(
          fieldErrors: {'email': 'Required'},
          message: 'Validation errors occurred',
        ).message,
        equals('Validation errors occurred'),
      );
    });
  });
}
