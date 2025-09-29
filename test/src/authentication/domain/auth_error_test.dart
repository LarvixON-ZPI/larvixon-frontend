import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/src/authentication/domain/auth_error.dart';

void main() {
  group('AuthError', () {
    test('should parse invalid credentials error from Django response', () {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: {
          'non_field_errors': ['Invalid email or password.'],
        },
      );
      final dioException = DioException(
        requestOptions: RequestOptions(),
        response: response,
      );

      // Act
      final error = AuthError.fromDioException(dioException);

      // Assert
      expect(error, isA<InvalidCredentialsError>());
      expect(error.message, equals('Invalid email or password'));
    });

    test('should parse disabled account error from Django response', () {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: {
          'non_field_errors': ['Account is disabled.'],
        },
      );
      final dioException = DioException(
        requestOptions: RequestOptions(),
        response: response,
      );

      // Act
      final error = AuthError.fromDioException(dioException);

      // Assert
      expect(error, isA<DisabledAccountError>());
      expect(error.message, equals('Account is disabled'));
    });

    test('should parse field validation errors from Django response', () {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: {
          'email': ['This field is required.'],
          'password': ['This field is required.'],
        },
      );
      final dioException = DioException(
        requestOptions: RequestOptions(),
        response: response,
      );

      // Act
      final error = AuthError.fromDioException(dioException);

      // Assert
      expect(error, isA<FieldValidationError>());
      final fieldError = error as FieldValidationError;
      expect(fieldError.hasFieldError('email'), isTrue);
      expect(fieldError.hasFieldError('password'), isTrue);
      expect(
        fieldError.getFieldError('email'),
        equals('This field is required.'),
      );
      expect(
        fieldError.getFieldError('password'),
        equals('This field is required.'),
      );
    });

    test('should parse MFA required from Django response', () {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 202,
        data: {'detail': 'MFA is required.'},
      );
      final dioException = DioException(
        requestOptions: RequestOptions(),
        response: response,
      );

      // Act
      final error = AuthError.fromDioException(dioException);

      // Assert
      expect(error, isA<MfaRequiredButNoCodeError>());
      expect(error.message, equals('Multi-factor authentication is required'));
    });

    test('should parse invalid MFA code error from Django response', () {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: {'detail': 'Invalid MFA code.'},
      );
      final dioException = DioException(
        requestOptions: RequestOptions(),
        response: response,
      );

      // Act
      final error = AuthError.fromDioException(dioException);

      // Assert
      expect(error, isA<InvalidMfaCodeError>());
      expect(error.message, equals('Invalid MFA code'));
    });

    test('should handle network errors', () {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );

      // Act
      final error = AuthError.fromDioException(dioException);

      // Assert
      expect(error, isA<NetworkError>());
      expect(error.message, equals('Network connection failed'));
    });
  });
}
