// TODO: Review and localize
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
