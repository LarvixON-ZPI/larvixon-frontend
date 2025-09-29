import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/core/constants/endpoints_analysis.dart';
import 'package:larvixon_frontend/src/analysis/data/models/analysis_dto.dart';
import 'package:larvixon_frontend/src/analysis/data/models/analysis_id_list_dto.dart';

class AnalysisDatasource {
  final ApiClient apiClient;

  AnalysisDatasource({required this.apiClient});

  Future<AnalysisIdListDTO> fetchAnalysisIds({String? nextPage}) async {
    if (nextPage != null) {
      final response = await apiClient.dio.get(nextPage);
      return AnalysisIdListDTO.fromMap(response.data);
    } else {
      final response = await apiClient.dio.get(AnalysisEndpoints.videoIDs);
      return AnalysisIdListDTO.fromMap(response.data);
    }
  }

  Future<AnalysisDTO> fetchAnalysisDetailsById(int id) async {
    final response = await apiClient.dio.get(
      AnalysisEndpoints.analysisById(id),
    );
    return AnalysisDTO.fromMap(response.data);
  }

  Future<Map<String, dynamic>> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) async {
    final formData = FormData.fromMap({
      'video': MultipartFile.fromBytes(bytes, filename: filename),
      'title': title,
    });
    final response = await apiClient.dio.post(
      AnalysisEndpoints.uploadVideo,
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );
    return response.data;
  }
}

// abstract class LarvaVideoRepository {
//   Future<List<int>> fetchVideoIds();
//   Future<LarvaVideo> fetchVideoDetailsById(int id);
//   Future<List<LarvaVideo>> fetchVideosDetails();
//   Future<void> addVideo(LarvaVideo video);
//   Stream<LarvaVideo> watchVideoProgressById({
//     required int id,
//     Duration interval = const Duration(seconds: 5),
//   });
// }
