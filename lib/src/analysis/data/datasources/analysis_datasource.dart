import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/core/constants/endpoints_analysis.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/analysis_sort_query_params.dart';
import 'package:larvixon_frontend/src/analysis/data/models/analysis_dto.dart';
import 'package:larvixon_frontend/src/analysis/data/models/analysis_id_list_dto.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';

class AnalysisDatasource {
  final ApiClient apiClient;

  AnalysisDatasource({required this.apiClient});

  Future<AnalysisIdListDTO> fetchAnalysisIds({
    String? nextPage,
    AnalysisSort? sort,
    AnalysisFilter? filter,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (sort != null) {
      queryParameters['ordering'] = sort.toQueryParam();
    }
    if (filter != null) {
      final status = filter.status;
      if (status != null) {
        queryParameters['status'] = status.name;
      }
      final createdAtRange = filter.createAtDateRange;
      if (createdAtRange != null) {
        String formatDate(DateTime d) =>
            "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

        final createdAtStart = createdAtRange.start;
        final createdAtEnd = createdAtRange.end;
        queryParameters['created_at__date__gte'] = formatDate(createdAtStart);
        queryParameters['created_at__date__lte'] = formatDate(createdAtEnd);
      }
    }

    if (nextPage != null) {
      final response = await apiClient.dio.get(
        nextPage,
        queryParameters: queryParameters,
      );
      return AnalysisIdListDTO.fromMap(response.data);
    } else {
      final response = await apiClient.dio.get(
        AnalysisEndpoints.videoIDs,
        queryParameters: queryParameters,
      );
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
