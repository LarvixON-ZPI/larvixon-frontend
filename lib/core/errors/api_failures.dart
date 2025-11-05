import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';

/// Base class representing an API-level failure, mapped from HTTP responses.
///
/// Use [ApiFailure.fromResponse] to convert
/// network exceptions into typed domain failures.
base class ApiFailure extends Failure {
  final int statusCode;
  const ApiFailure({required this.statusCode, required super.message});
  factory ApiFailure.fromResponse(Response? response) {
    final statusCode = response?.statusCode ?? -1;
    final data = response?.data;
    if (response == null) {
      return const UnknownApiFailure(statusCode: 0, message: 'Unknown error');
    }
    switch (statusCode) {
      case 400:
        final fieldErrors = _extractFieldErrors(data);
        if (fieldErrors.isNotEmpty) {
          return ValidationFailure(
            fieldErrors: fieldErrors,
            message: 'validation_failed',
            responseData: data,
          );
        }
        return const BadRequestFailure(message: 'bad_request');
      case 401:
        return const UnauthorizedFailure(message: 'unauthorized');
      case 403:
        return const ForbiddenFailure(message: 'forbidden');
      case 404:
        return const NotFoundFailure(message: 'not_found');
      case 405:
        return const MethodNotAllowedFailure(message: 'method_not_allowed');
      case 408:
        return const RequestTimeoutFailure(message: 'request_timeout');
      case 409:
        return const ConflictFailure(message: 'conflict');
      case 410:
        return const GoneFailure(message: 'gone');
      case 415:
        return const UnsupportedMediaTypeFailure(
          message: 'unsupported_media_type',
        );
      case 422:
        return const UnprocessableEntityFailure(
          message: 'unprocessable_entity',
        );
      case 429:
        return const TooManyRequestsFailure(message: 'too_many_requests');
      case 500:
        return const InternalServerErrorFailure(
          message: 'internal_server_error',
        );
      case 502:
        return const BadGatewayFailure(message: 'bad_gateway');
      case 503:
        return const ServiceUnavailableFailure(message: 'service_unavailable');
      case 504:
        return const GatewayTimeoutFailure(message: 'gateway_timeout');
      default:
        return UnknownApiFailure(
          statusCode: statusCode,
          message: 'unknown_error',
        );
    }
  }
  static Map<String, String> _extractFieldErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return {};
    final fieldErrors = <String, String>{};
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        fieldErrors[entry.key] = value.first.toString();
      }
    }
    return fieldErrors;
  }
}

/// 200 OK but missing required data
final class MalformedResponseFailure extends ApiFailure {
  const MalformedResponseFailure({
    required super.message,
    super.statusCode = 200,
  });
}

/// 400 Bad Request
base class BadRequestFailure extends ApiFailure {
  const BadRequestFailure({required super.message}) : super(statusCode: 400);
}

/// 400 Bad Request – with field validation errors
base class ValidationFailure extends BadRequestFailure {
  final Map<String, String> fieldErrors;
  final dynamic responseData;

  const ValidationFailure({
    required this.fieldErrors,
    this.responseData,
    required super.message,
  });
  @override
  String toString() {
    return "${super.toString()} ($fieldErrors)";
  }
}

/// 401 Unauthorized
final class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure({required super.message}) : super(statusCode: 401);
}

/// 403 Forbidden
final class ForbiddenFailure extends ApiFailure {
  const ForbiddenFailure({required super.message}) : super(statusCode: 403);
}

/// 404 Not Found
final class NotFoundFailure extends ApiFailure {
  const NotFoundFailure({required super.message}) : super(statusCode: 404);
}

/// 405 Method Not Allowed
final class MethodNotAllowedFailure extends ApiFailure {
  const MethodNotAllowedFailure({required super.message})
    : super(statusCode: 405);
}

/// 408 Request Timeout
final class RequestTimeoutFailure extends ApiFailure {
  const RequestTimeoutFailure({required super.message})
    : super(statusCode: 408);
}

/// 409 Conflict
final class ConflictFailure extends ApiFailure {
  const ConflictFailure({required super.message}) : super(statusCode: 409);
}

/// 410 Gone
final class GoneFailure extends ApiFailure {
  const GoneFailure({required super.message}) : super(statusCode: 410);
}

/// 415 Unsupported Media Type
final class UnsupportedMediaTypeFailure extends ApiFailure {
  const UnsupportedMediaTypeFailure({required super.message})
    : super(statusCode: 415);
}

/// 422 Unprocessable Entity
final class UnprocessableEntityFailure extends ApiFailure {
  const UnprocessableEntityFailure({required super.message})
    : super(statusCode: 422);
}

/// 429 Too Many Requests (Rate limiting)
final class TooManyRequestsFailure extends ApiFailure {
  const TooManyRequestsFailure({required super.message})
    : super(statusCode: 429);
}

/// 500 Internal Server Error
final class InternalServerErrorFailure extends ApiFailure {
  const InternalServerErrorFailure({required super.message})
    : super(statusCode: 500);
}

/// 502 Bad Gateway
final class BadGatewayFailure extends ApiFailure {
  const BadGatewayFailure({required super.message}) : super(statusCode: 502);
}

/// 503 Service Unavailable
final class ServiceUnavailableFailure extends ApiFailure {
  const ServiceUnavailableFailure({required super.message})
    : super(statusCode: 503);
}

/// 504 Gateway Timeout
final class GatewayTimeoutFailure extends ApiFailure {
  const GatewayTimeoutFailure({required super.message})
    : super(statusCode: 504);
}

/// Unknown or unhandled status code
final class UnknownApiFailure extends ApiFailure {
  const UnknownApiFailure({required super.statusCode, required super.message});
}

extension ApiFailureMapperX on DioException {
  ApiFailure toApiFailure() {
    if (response == null) {
      switch (type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const RequestTimeoutFailure(message: 'timeout');
        case DioExceptionType.connectionError:
          return const ServiceUnavailableFailure(message: 'no_connection');
        default:
          return const UnknownApiFailure(
            statusCode: 0,
            message: 'Unknown error',
          );
      }
    }
    return ApiFailure.fromResponse(response);
  }
}
