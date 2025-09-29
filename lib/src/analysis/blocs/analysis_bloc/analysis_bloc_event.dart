part of 'analysis_bloc.dart';

sealed class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object> get props => [];
}

final class FetchAnalysisDetails extends AnalysisEvent {
  final bool refresh;
  final int videoId;
  const FetchAnalysisDetails({required this.videoId, this.refresh = false});

  @override
  List<Object> get props => [refresh, videoId];
}

final class UpdateAnalysisDetails extends AnalysisEvent {
  final LarvaVideo video;
  const UpdateAnalysisDetails({required this.video});

  @override
  List<Object> get props => [video];
}

final class RemoveAnalysis extends AnalysisEvent {
  final int videoId;
  const RemoveAnalysis({required this.videoId});

  @override
  List<Object> get props => [videoId];
}
