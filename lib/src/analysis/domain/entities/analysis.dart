// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';

class Analysis extends Equatable {
  final int id;
  final DateTime uploadedAt;
  final AnalysisProgressStatus status;
  final String? errorMessage;
  final DateTime? analysedAt;
  final String? thumbnailUrl;
  final AnalysisResults? results;
  final String? description;

  const Analysis({
    required this.id,
    required this.uploadedAt,
    this.status = AnalysisProgressStatus.pending,
    this.analysedAt,
    this.thumbnailUrl,
    this.results,
    this.description,
    this.errorMessage,
  });

  Analysis copyWith({
    int? id,
    DateTime? uploadedAt,
    AnalysisProgressStatus? status,
    double? progress,
    String? errorMessage,
    DateTime? analysedAt,
    AnalysisResults? results,
    String? thumbnailUrl,
    String? description,
  }) {
    return Analysis(
      id: id ?? this.id,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      analysedAt: analysedAt ?? this.analysedAt,
      results: results ?? this.results,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    id,
    uploadedAt,
    status,
    errorMessage,
    analysedAt,
    results,
    thumbnailUrl,
  ];
}
