import 'package:larvixon_frontend/core/errors/api_failures.dart';

extension ValidationFailureHelpers on ValidationFailure {
  bool hasFieldError(String fieldName) {
    final error = fieldErrors[fieldName];
    return error != null && error.isNotEmpty;
  }

  String? getFieldError(String fieldName) {
    final error = fieldErrors[fieldName];
    if (error == null || error.isEmpty) return null;
    return error;
  }
}
