import 'dart:io';

import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/constants/endpoints_analysis.dart';
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
    final formData = FormData.fromMap({
      'video': MultipartFile.fromStream(
        () async* {
          await for (final chunk in streamFactory()) {
            yield chunk;
            await Future.delayed(const Duration(milliseconds: 1));
          }
        },
        totalBytes,
        filename: filename,
      ),
      if (description != null) 'description': description,
      if (patientId != null) 'patient_guid': patientId,
    });
    final response = await apiClient.dio.post(
      AnalysisEndpoints.uploadVideo,
      cancelToken: cancelToken,
      data: formData,
      onSendProgress: onProgress,
    );
    return response.data;
  }

  Stream<List<int>> readFileChunks(
    File file, {
    int chunkSize = 64 * 1024,
  }) async* {
    final raf = await file.open();
    int offset = 0;
    while (offset < await file.length()) {
      await Future.delayed(const Duration(milliseconds: 1));
      final end = (offset + chunkSize > await file.length())
          ? await file.length()
          : offset + chunkSize;
      final chunk = await raf.read(end - offset);
      yield chunk;
      offset = end;
    }
    await raf.close();
  }
}
