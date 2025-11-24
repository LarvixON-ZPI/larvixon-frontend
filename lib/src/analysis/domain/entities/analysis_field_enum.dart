import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

/// Used purely for sorting and filtering
enum AnalysisField { createdAt, status }

extension AnalysisFieldHelpers on AnalysisField {
  String displayName(BuildContext context) {
    switch (this) {
      case AnalysisField.createdAt:
        return context.translate.createdAt;

      case AnalysisField.status:
        return context.translate.status;
    }
  }

  bool get isSortable {
    switch (this) {
      case AnalysisField.createdAt:
        return true;
      case AnalysisField.status:
        return false;
    }
  }
}
