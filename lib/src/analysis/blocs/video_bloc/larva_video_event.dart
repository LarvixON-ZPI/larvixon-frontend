part of 'larva_video_bloc.dart';

sealed class LarvaVideoEvent extends Equatable {
  const LarvaVideoEvent();

  @override
  List<Object> get props => [];
}

final class FetchLarvaVideoDetails extends LarvaVideoEvent {
  final bool refresh;
  final int videoId;
  const FetchLarvaVideoDetails({required this.videoId, this.refresh = false});

  @override
  List<Object> get props => [refresh, videoId];
}

final class UpdateLarvaVideoDetails extends LarvaVideoEvent {
  final LarvaVideo video;
  const UpdateLarvaVideoDetails({required this.video});

  @override
  List<Object> get props => [video];
}

final class DeleteLarvaVideo extends LarvaVideoEvent {
  final int videoId;
  const DeleteLarvaVideo({required this.videoId});

  @override
  List<Object> get props => [videoId];
}
