part of 'larva_video_bloc.dart';

enum LarvaVideoBlocStatus { initial, loading, success, error }

final class LarvaVideoState extends Equatable {
  final LarvaVideoBlocStatus status;
  final LarvaVideo? video;
  final String? errorMessage;
  final double progress;
  const LarvaVideoState({
    this.status = LarvaVideoBlocStatus.initial,
    this.video,
    this.errorMessage,
    this.progress = 0.0,
  });
  LarvaVideoState copyWith({
    LarvaVideoBlocStatus? status,
    LarvaVideo? video,
    String? errorMessage,
    double? progress,
  }) {
    return LarvaVideoState(
      status: status ?? this.status,
      video: video ?? this.video,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [status, video, errorMessage, progress];
}
