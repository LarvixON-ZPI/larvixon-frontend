// TODO: Review and localize
base class Failure {
  final String message;
  const Failure({required this.message});
}

final class ApiFailure extends Failure {
  final int statusCode;
  ApiFailure({required this.statusCode, required super.message});
}

final class UnknownFailure extends Failure {
  UnknownFailure({required super.message});
}

sealed class ApiError implements Exception {
  final String message;
  ApiError(this.message);
}

final class UnauthorizedError extends ApiError {
  UnauthorizedError() : super('Unauthorized');
}

final class NotFoundError extends ApiError {
  NotFoundError() : super('Not Found');
}

final class InternalServerError extends ApiError {
  InternalServerError() : super('Internal Server Error');
}
