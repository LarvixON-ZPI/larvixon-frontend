import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_error.dart';

void main() {
  group('FieldValidationError', () {
    test('should correctly identify field errors', () {
      // Arrange
      const fieldErrors = {
        'email': ['This field is required.'],
        'password': [
          'Password is too short.',
          'Password must contain numbers.',
        ],
        'username': <String>[],
      };
      const error = FieldValidationError(fieldErrors);

      // Act & Assert
      expect(error.hasFieldError('email'), isTrue);
      expect(error.hasFieldError('password'), isTrue);
      expect(
        error.hasFieldError('username'),
        isFalse,
      ); // Empty list should return false
      expect(error.hasFieldError('nonexistent'), isFalse);
    });

    test('should return first error message for a field', () {
      // Arrange
      const fieldErrors = {
        'email': ['This field is required.'],
        'password': [
          'Password is too short.',
          'Password must contain numbers.',
        ],
      };
      const error = FieldValidationError(fieldErrors);

      // Act & Assert
      expect(error.getFieldError('email'), equals('This field is required.'));
      expect(error.getFieldError('password'), equals('Password is too short.'));
      expect(error.getFieldError('nonexistent'), isNull);
    });

    test('should return null for empty error lists', () {
      // Arrange
      const fieldErrors = {'username': <String>[]};
      const error = FieldValidationError(fieldErrors);

      // Act & Assert
      expect(error.getFieldError('username'), isNull);
      expect(error.hasFieldError('username'), isFalse);
    });

    test('should have correct error message', () {
      // Arrange
      const fieldErrors = {
        'email': ['This field is required.'],
      };
      const error = FieldValidationError(fieldErrors);

      // Act & Assert
      expect(error.message, equals('Validation errors occurred'));
    });
  });

  group('Error Type Hierarchy', () {
    test('should correctly identify error types', () {
      const invalidCredentials = InvalidCredentialsError();
      const disabledAccount = DisabledAccountError();
      const mfaRequired = MfaRequiredButNoCodeError();
      const invalidMfaCode = InvalidMfaCodeError();
      const networkError = NetworkError('Connection failed');
      const serverError = ServerError('Internal error');
      const fieldError = FieldValidationError({
        'email': ['Required'],
      });

      // Test AuthError base type
      expect(invalidCredentials, isA<AuthError>());
      expect(disabledAccount, isA<AuthError>());
      expect(mfaRequired, isA<AuthError>());
      expect(invalidMfaCode, isA<AuthError>());
      expect(networkError, isA<AuthError>());
      expect(serverError, isA<AuthError>());
      expect(fieldError, isA<AuthError>());

      // Test specific types
      expect(invalidCredentials, isA<InvalidCredentialsError>());
      expect(disabledAccount, isA<DisabledAccountError>());
      expect(mfaRequired, isA<MfaRequiredButNoCodeError>());
      expect(invalidMfaCode, isA<InvalidMfaCodeError>());
      expect(networkError, isA<NetworkError>());
      expect(serverError, isA<ServerError>());
      expect(fieldError, isA<FieldValidationError>());

      // Test MFA inheritance
      expect(mfaRequired, isA<MfaError>());
      expect(invalidMfaCode, isA<MfaError>());
    });

    test('should have correct error messages', () {
      expect(
        const InvalidCredentialsError().message,
        equals('Invalid email or password'),
      );
      expect(const DisabledAccountError().message, equals('Account is disabled'));
      expect(
        const MfaRequiredButNoCodeError().message,
        equals('Multi-factor authentication is required'),
      );
      expect(const InvalidMfaCodeError().message, equals('Invalid MFA code'));
      expect(
        const NetworkError('Connection failed').message,
        equals('Connection failed'),
      );
      expect(const ServerError('Internal error').message, equals('Internal error'));
      expect(
        const FieldValidationError({
          'email': ['Required'],
        }).message,
        equals('Validation errors occurred'),
      );
    });
  });
}
