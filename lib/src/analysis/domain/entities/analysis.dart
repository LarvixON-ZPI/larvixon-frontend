// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';

class Analysis extends Equatable {
  final int id;
  final DateTime uploadedAt;
  final AnalysisProgressStatus status;
  final String? errorMessage;
  final String? description;
  final DateTime? analysedAt;
  final String? thumbnailUrl;
  final Patient? patient;
  final AnalysisResults? results;

  const Analysis({
    required this.id,
    required this.uploadedAt,
    this.description,
    this.status = AnalysisProgressStatus.pending,
    this.analysedAt,
    this.thumbnailUrl,
    this.results,
    this.patient,
    this.errorMessage,
  });

  Analysis copyWith({
    int? id,
    DateTime? uploadedAt,
    AnalysisProgressStatus? status,
    double? progress,
    String? errorMessage,
    String? description,
    DateTime? analysedAt,
    AnalysisResults? results,
    String? patientId,
    String? thumbnailUrl,
    Patient? patient,
  }) {
    return Analysis(
      id: id ?? this.id,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      description: description ?? this.description,
      analysedAt: analysedAt ?? this.analysedAt,
      results: results ?? this.results,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      patient: patient ?? this.patient,
    );
  }

  @override
  List<Object?> get props => [
    id,
    uploadedAt,
    status,
    errorMessage,
    description,
    analysedAt,
    results,
    thumbnailUrl,
    patient,
  ];
}
