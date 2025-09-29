import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

enum AnalysisProgressStatus {
  pending,
  processing,
  completed,
  failed;

  AnalysisProgressStatus progressStatus() {
    switch (this) {
      case AnalysisProgressStatus.pending:
        return AnalysisProgressStatus.processing;
      case AnalysisProgressStatus.processing:
        return AnalysisProgressStatus.completed;
      case AnalysisProgressStatus.completed:
      case AnalysisProgressStatus.failed:
        return this;
    }
  }

  String displayName(BuildContext context) {
    switch (this) {
      case AnalysisProgressStatus.pending:
        return context.translate.pending;
      case AnalysisProgressStatus.processing:
        return context.translate.processing;
      case AnalysisProgressStatus.completed:
        return context.translate.completed;
      case AnalysisProgressStatus.failed:
        return context.translate.failed;
    }
  }

  double get progressValue {
    switch (this) {
      case AnalysisProgressStatus.pending:
      case AnalysisProgressStatus.failed:
        return 0.0;
      case AnalysisProgressStatus.processing:
        return 0.5;
      case AnalysisProgressStatus.completed:
        return 1.0;
    }
  }

  IconData get icon {
    switch (this) {
      case AnalysisProgressStatus.pending:
        return Icons.hourglass_empty;
      case AnalysisProgressStatus.processing:
        return Icons.autorenew;
      case AnalysisProgressStatus.completed:
        return Icons.check_circle;
      case AnalysisProgressStatus.failed:
        return Icons.error;
    }
  }

  Color get color {
    switch (this) {
      case AnalysisProgressStatus.pending:
        return Colors.grey;
      case AnalysisProgressStatus.processing:
        return Colors.blue;
      case AnalysisProgressStatus.completed:
        return Colors.green;
      case AnalysisProgressStatus.failed:
        return Colors.red;
    }
  }

  static AnalysisProgressStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AnalysisProgressStatus.pending;
      case 'processing':
        return AnalysisProgressStatus.processing;
      case 'completed':
        return AnalysisProgressStatus.completed;
      case 'failed':
        return AnalysisProgressStatus.failed;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }
}
