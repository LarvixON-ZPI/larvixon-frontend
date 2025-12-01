import 'package:dio/dio.dart';
import 'package:larvixon_frontend/src/analysis/data/datasources/analysis_datasource.dart';

class AnalysisDataSourceImpl extends AnalysisDataSource {
  AnalysisDataSourceImpl({required super.apiClient});

  @override
  Future<Map<String, dynamic>> uploadVideo({
    required Stream<List<int>> Function({CancelToken? cancelToken})
    streamFactory,
    required dynamic file,
    required String filename,
    String? description,
    required int totalBytes,
    String? patientId,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError("Stub implementation");
  }
}
