import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

extension AnalysisSortQueryParams on AnalysisSort {
  String toQueryParam() {
    final String orderPrefix = order == SortOrder.descending ? '-' : '';
    final String fieldName = _fieldToApiName(field);
    return '$orderPrefix$fieldName';
  }

  String _fieldToApiName(AnalysisSortField field) {
    return switch (field) {
      AnalysisSortField.createdAt => 'created_at',
      AnalysisSortField.title => 'title',
    };
  }
}
