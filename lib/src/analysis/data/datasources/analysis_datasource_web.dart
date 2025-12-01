import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/constants/endpoints_analysis.dart';
import 'package:larvixon_frontend/core/token_storage.dart';
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
    final completer = Completer<Map<String, dynamic>>();
    final xhr = html.HttpRequest();
    final url = AnalysisEndpoints.uploadVideo;

    final formData = html.FormData();
    formData.appendBlob('video', file, filename);
    if (description != null) formData.append('description', description);
    if (patientId != null) formData.append('patient_guid', patientId);

    xhr.upload.onProgress.listen((html.ProgressEvent e) {
      if (e.lengthComputable) {
        final loaded = (e.loaded ?? 0).toInt();
        final total = (e.total ?? 0).toInt();
        onProgress?.call(loaded, total);
      }
    });

    xhr.onLoad.listen((e) {
      final statusCode = xhr.status!;

      if (statusCode >= 200 && statusCode < 300) {
        try {
          final responseText = xhr.responseText;
          if (responseText!.isEmpty) {
            completer.complete({});
            return;
          }
          final response = json.decode(responseText);
          completer.complete(response is Map<String, dynamic> ? response : {});
        } catch (err) {
          completer.completeError(
            DioException(
              requestOptions: RequestOptions(path: url),
              error: err,
              message: 'Failed to parse response: $err',
            ),
          );
        }
      } else {
        completer.completeError(
          DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: url),
              statusCode: statusCode,
              statusMessage: xhr.statusText,
              data: xhr.responseText,
            ),
            message: 'HTTP error $statusCode: ${xhr.statusText}',
          ),
        );
      }
    });

    xhr.onError.listen((e) {
      final statusCode = (xhr.status == 0) ? 404 : xhr.status!;
      completer.completeError(
        DioException(
          requestOptions: RequestOptions(path: url),
          type: DioExceptionType.connectionError,
          response: Response(
            requestOptions: RequestOptions(path: url),
            statusCode: statusCode,
            statusMessage: xhr.statusText,
          ),
          message: '',
        ),
      );
    });

    cancelToken?.whenCancel.then((_) {
      if (!completer.isCompleted) {
        xhr.abort();
        completer.completeError(
          DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.cancel,
            message: 'Upload cancelled',
          ),
        );
      }
    });

    try {
      xhr.open('POST', url);
      final token = await TokenStorage().getAccessToken();
      xhr.setRequestHeader('Authorization', 'Bearer $token');
      xhr.send(formData);
    } catch (err) {
      completer.completeError(
        DioException(
          requestOptions: RequestOptions(path: url),
          error: err,
          message: 'Failed to send request: $err',
        ),
      );
    }

    return completer.future;
  }
}
