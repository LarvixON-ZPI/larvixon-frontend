import 'package:larvixon_frontend/core/errors/failures.dart';

sealed class VideoFailure extends Failure {
  const VideoFailure({required super.message});
}

final class UploadFailure extends VideoFailure {
  const UploadFailure({required super.message});
}

final class VideoNotFoundFailure extends VideoFailure {
  const VideoNotFoundFailure({required super.message});
}

final class UnknownVideoFailure extends VideoFailure {
  const UnknownVideoFailure({required super.message});
}

final class VideoApiFailure extends VideoFailure {
  final ApiFailure apiFailure;
  const VideoApiFailure({required this.apiFailure, required super.message});
}
