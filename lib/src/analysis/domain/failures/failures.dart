import 'package:larvixon_frontend/core/errors/failures.dart';

sealed class AnalysisFailure extends Failure {
  const AnalysisFailure({required super.message});
}

final class UploadFailure extends AnalysisFailure {
  const UploadFailure({required super.message});
}

final class AnalysisNotFoundFailure extends AnalysisFailure {
  const AnalysisNotFoundFailure({required super.message});
}

final class UnknownAnalysisFailure extends AnalysisFailure {
  const UnknownAnalysisFailure({required super.message});
}

final class AnalysisApiFailure extends AnalysisFailure {
  final ApiFailure apiFailure;
  const AnalysisApiFailure({required this.apiFailure, required super.message});
}
