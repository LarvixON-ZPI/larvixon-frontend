part of 'analysis_bloc.dart';

enum AnalysisStatus { initial, loading, success, error }

final class AnalysisState extends Equatable {
  final AnalysisStatus status;
  final Analysis? analysis;
  final String? errorMessage;
  final double progress;
  const AnalysisState({
    this.status = AnalysisStatus.initial,
    this.analysis,
    this.errorMessage,
    this.progress = 0.0,
  });
  AnalysisState copyWith({
    AnalysisStatus? status,
    Analysis? analysis,
    String? errorMessage,
    double? progress,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      analysis: analysis ?? this.analysis,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [status, analysis, errorMessage, progress];
}
