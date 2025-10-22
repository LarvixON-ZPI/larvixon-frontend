import 'package:larvixon_frontend/core/constants/api_base.dart';

class AnalysisEndpoints {
  static const String videoIDs = '${ApiBase.baseUrl}/analysis/ids/';
  static String analysisById(int id) => '${ApiBase.baseUrl}/analysis/$id/';
  static String uploadVideo = '${ApiBase.baseUrl}/videoprocessor/upload/';
}
