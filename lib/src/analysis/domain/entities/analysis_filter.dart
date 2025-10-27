import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';

@immutable
class AnalysisFilter extends Equatable {
  final DateTimeRange? createAtDateRange;
  final AnalysisProgressStatus? status;

  const AnalysisFilter({this.createAtDateRange, this.status});
  const AnalysisFilter.empty() : createAtDateRange = null, status = null;

  AnalysisFilter copyWith({
    DateTimeRange? dateRange,
    AnalysisProgressStatus? status,
  }) {
    return AnalysisFilter(
      createAtDateRange: dateRange ?? createAtDateRange,
      status: status ?? this.status,
    );
  }

  /// Applies the filter to a list of analyses.
  List<Analysis> applyFilter(List<Analysis> analyses) {
    final List<Analysis> filtered = analyses.where((analysis) {
      final matchesDateRange =
          createAtDateRange == null ||
          (analysis.uploadedAt.isAfter(createAtDateRange!.start) &&
              analysis.uploadedAt.isBefore(createAtDateRange!.end));
      final matchesStatus = status == null || analysis.status == status;

      return matchesDateRange && matchesStatus;
    }).toList();
    return filtered;
  }

  @override
  List<Object?> get props => [createAtDateRange, status];
}
