part of 'analysis_bloc.dart';

sealed class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object> get props => [];
}

final class FetchAnalysisDetails extends AnalysisEvent {
  final bool refresh;
  final int analysisId;
  const FetchAnalysisDetails({required this.analysisId, this.refresh = false});

  @override
  List<Object> get props => [refresh, analysisId];
}

final class UpdateAnalysisDetails extends AnalysisEvent {
  final Analysis analysis;
  const UpdateAnalysisDetails({required this.analysis});

  @override
  List<Object> get props => [analysis];
}

final class RemoveAnalysis extends AnalysisEvent {
  final int analysisId;
  const RemoveAnalysis({required this.analysisId});

  @override
  List<Object> get props => [analysisId];
}
