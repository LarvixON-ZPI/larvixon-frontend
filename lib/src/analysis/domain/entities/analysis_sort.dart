import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

enum AnalysisSortField { createdAt, title }

class AnalysisSort {
  final AnalysisSortField field;
  final SortOrder order;

  const AnalysisSort({required this.field, required this.order});

  const AnalysisSort.defaultSorting()
    : field = AnalysisSortField.createdAt,
      order = SortOrder.descending;

  AnalysisSort copyWith({AnalysisSortField? field, SortOrder? order}) {
    return AnalysisSort(field: field ?? this.field, order: order ?? this.order);
  }
}

extension AnalysisSortFieldTranslation on AnalysisSortField {
  String translate(BuildContext context) {
    switch (this) {
      case AnalysisSortField.createdAt:
        return context.translate.createdAt;
      case AnalysisSortField.title:
        return context.translate.title;
    }
  }
}
