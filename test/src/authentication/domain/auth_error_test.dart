import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/validation_failure_extensions.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';

void main() {
  group('AuthFailure', () {
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
      var error = dioException.toApiFailure();
      expect(error, isA<BadRequestFailure>());

      error = AuthFailure.fromBadRequest(error as BadRequestFailure);

      // Assert
      expect(error, isA<InvalidCredentialsFailure>());
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
      var error = dioException.toApiFailure();
      expect(error, isA<BadRequestFailure>());

      error = AuthFailure.fromBadRequest(error as BadRequestFailure);

      // Assert
      expect(error, isA<DisabledAccountFailure>());
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
      var error = dioException.toApiFailure();
      expect(error, isA<ValidationFailure>());
      final fieldError = error as ValidationFailure;
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

    test('should parse MFA device not found from Django response', () {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: {'detail': 'MFA device not found.'},
      );
      final dioException = DioException(
        requestOptions: RequestOptions(),
        response: response,
      );

      // Act
      var error = dioException.toApiFailure();
      expect(error, isA<BadRequestFailure>());

      error = AuthFailure.fromBadRequest(error as BadRequestFailure);

      // Assert
      expect(error, isA<MfaDeviceNotFoundFailure>());
      expect(error.message, equals('MFA device not found'));
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
      var error = dioException.toApiFailure();
      expect(error, isA<BadRequestFailure>());

      error = AuthFailure.fromBadRequest(error as BadRequestFailure);

      // Assert
      expect(error, isA<InvalidMfaCodeFailure>());
      expect(error.message, equals('Invalid MFA code'));
    });

    test('should handle network timeout errors', () {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      final error = dioException.toApiFailure();

      // Assert
      expect(error, isA<RequestTimeoutFailure>());
      expect(error.message, equals('timeout'));
    });

    test('should handle network connection errors', () {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );

      // Act
      final error = dioException.toApiFailure();

      // Assert
      expect(error, isA<ServiceUnavailableFailure>());
      expect(error.message, equals('no_connection'));
    });
  });
}
