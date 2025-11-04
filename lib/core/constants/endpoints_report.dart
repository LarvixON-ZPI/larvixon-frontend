import 'package:larvixon_frontend/core/constants/api_base.dart';

class ReportEndpoints {
  static String reportPdfByAnalysisId(int id) =>
      '${ApiBase.baseUrl}/reports/analysis/$id/pdf/';
}
