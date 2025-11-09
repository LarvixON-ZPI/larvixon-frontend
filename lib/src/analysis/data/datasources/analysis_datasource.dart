import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/core/constants/endpoints_analysis.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/analysis_sort_query_params.dart';
import 'package:larvixon_frontend/src/analysis/data/models/analysis_dto.dart';
import 'package:larvixon_frontend/src/analysis/data/models/analysis_id_list_dto.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';

import 'package:larvixon_frontend/src/analysis/data/datasources/analysis_datasource_stub.dart'
    if (dart.library.html) 'analysis_datasource_web.dart'
    if (dart.library.io) 'analysis_datasource_io.dart';

abstract class AnalysisDataSource {
  final ApiClient apiClient;
  AnalysisDataSource({required this.apiClient});

  factory AnalysisDataSource.getImplementation(ApiClient apiClient) =>
      AnalysisDataSourceImpl(apiClient: apiClient);
  Future<Map<String, dynamic>> uploadVideo({
    required Stream<List<int>> Function({CancelToken? cancelToken})
    streamFactory,
    required dynamic file,
    required String filename,
    required String title,
    required int totalBytes,

    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  });

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

  Future<bool> deleteAnalysis({required int id}) async {
    final response = await apiClient.dio.delete(
      AnalysisEndpoints.analysisById(id),
    );
    return response.statusCode == 204;
  }
}
