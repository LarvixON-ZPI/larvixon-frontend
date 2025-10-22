import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_field_enum.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

extension AnalysisSortQueryParams on AnalysisSort {
  String toQueryParam() {
    final String orderPrefix = order == SortOrder.descending ? '-' : '';
    final String fieldName = _fieldToApiName(field);
    return '$orderPrefix$fieldName';
  }

  String _fieldToApiName(AnalysisField field) {
    return switch (field) {
      AnalysisField.createdAt => 'created_at',
      AnalysisField.title => 'title',
      AnalysisField.status => 'status',
    };
  }
}
