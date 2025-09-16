part of 'larva_video_list_cubit.dart';

enum LarvaVideoListStatus { initial, loading, loadingMore, success, error }

final class LarvaVideoListState extends Equatable {
  final LarvaVideoListStatus status;
  final List<int> videoIds;
  final String? errorMessage;
  const LarvaVideoListState({
    this.status = LarvaVideoListStatus.initial,
    this.videoIds = const [],
    this.errorMessage,
  });

  LarvaVideoListState copyWith({
    LarvaVideoListStatus? status,
    List<int>? videoIds,
    String? errorMessage,
  }) {
    return LarvaVideoListState(
      status: status ?? this.status,
      videoIds: videoIds ?? this.videoIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, videoIds, errorMessage];
}
