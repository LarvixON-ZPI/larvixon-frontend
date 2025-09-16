import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

enum LarvaVideoStatus {
  pending,
  uploading,
  uploaded,
  analysing,
  analysed,
  error;

  LarvaVideoStatus progressStatus() {
    switch (this) {
      case LarvaVideoStatus.pending:
        return LarvaVideoStatus.uploading;
      case LarvaVideoStatus.uploading:
        return LarvaVideoStatus.analysing;
      case LarvaVideoStatus.uploaded:
        return LarvaVideoStatus.analysing;
      case LarvaVideoStatus.analysing:
        return LarvaVideoStatus.analysed;
      case LarvaVideoStatus.analysed:
      case LarvaVideoStatus.error:
        return this;
    }
  }

  String displayName(BuildContext context) {
    switch (this) {
      case LarvaVideoStatus.pending:
        return context.translate.pending;
      case LarvaVideoStatus.uploading:
        return context.translate.uploading;
      case LarvaVideoStatus.uploaded:
        return context.translate.uploaded;
      case LarvaVideoStatus.analysing:
        return context.translate.analysing;
      case LarvaVideoStatus.analysed:
        return context.translate.analysed;
      case LarvaVideoStatus.error:
        return context.translate.error;
    }
  }

  double get progressValue {
    switch (this) {
      case LarvaVideoStatus.pending:
        return 0.0;
      case LarvaVideoStatus.uploading:
        return 0.15;
      case LarvaVideoStatus.uploaded:
        return 0.3;
      case LarvaVideoStatus.analysing:
        return 0.5;
      case LarvaVideoStatus.analysed:
        return 1.0;
      case LarvaVideoStatus.error:
        return 0.0;
    }
  }

  IconData get icon {
    switch (this) {
      case LarvaVideoStatus.pending:
        return Icons.hourglass_empty;
      case LarvaVideoStatus.uploading:
        return Icons.cloud_upload;
      case LarvaVideoStatus.uploaded:
        return Icons.cloud_done;
      case LarvaVideoStatus.analysing:
        return Icons.search;
      case LarvaVideoStatus.analysed:
        return Icons.check_circle;
      case LarvaVideoStatus.error:
        return Icons.error;
    }
  }

  Color get color {
    switch (this) {
      case LarvaVideoStatus.pending:
        return Colors.grey;
      case LarvaVideoStatus.uploading:
      case LarvaVideoStatus.uploaded:
        return Colors.blue;
      case LarvaVideoStatus.analysing:
        return Colors.orange;
      case LarvaVideoStatus.analysed:
        return Colors.green;
      case LarvaVideoStatus.error:
        return Colors.red;
    }
  }
}
