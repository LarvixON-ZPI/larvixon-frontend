import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

enum LarvaVideoStatus {
  pending,
  processing,
  completed,
  failed;

  LarvaVideoStatus progressStatus() {
    switch (this) {
      case LarvaVideoStatus.pending:
        return LarvaVideoStatus.processing;
      case LarvaVideoStatus.processing:
        return LarvaVideoStatus.completed;
      case LarvaVideoStatus.completed:
      case LarvaVideoStatus.failed:
        return this;
    }
  }

  String displayName(BuildContext context) {
    switch (this) {
      case LarvaVideoStatus.pending:
        return context.translate.pending;
      case LarvaVideoStatus.processing:
        return context.translate.processing;
      case LarvaVideoStatus.completed:
        return context.translate.completed;
      case LarvaVideoStatus.failed:
        return context.translate.failed;
    }
  }

  double get progressValue {
    switch (this) {
      case LarvaVideoStatus.pending:
      case LarvaVideoStatus.failed:
        return 0.0;
      case LarvaVideoStatus.processing:
        return 0.5;
      case LarvaVideoStatus.completed:
        return 1.0;
    }
  }

  IconData get icon {
    switch (this) {
      case LarvaVideoStatus.pending:
        return Icons.hourglass_empty;
      case LarvaVideoStatus.processing:
        return Icons.autorenew;
      case LarvaVideoStatus.completed:
        return Icons.check_circle;
      case LarvaVideoStatus.failed:
        return Icons.error;
    }
  }

  Color get color {
    switch (this) {
      case LarvaVideoStatus.pending:
        return Colors.grey;
      case LarvaVideoStatus.processing:
        return Colors.blue;
      case LarvaVideoStatus.completed:
        return Colors.green;
      case LarvaVideoStatus.failed:
        return Colors.red;
    }
  }

  static LarvaVideoStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return LarvaVideoStatus.pending;
      case 'processing':
        return LarvaVideoStatus.processing;
      case 'completed':
        return LarvaVideoStatus.completed;
      case 'failed':
        return LarvaVideoStatus.failed;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }
}
