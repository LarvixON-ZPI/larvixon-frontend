import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/src/common/services/file_download/adaptive_file_download.dart';

class FileDownloadService {
  final ApiClient apiClient;

  FileDownloadService(this.apiClient);

  Future<void> downloadFile({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    Uint8List? bytes;

    try {
      final response = await apiClient.dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            onProgress?.call((received / total) * 0.5);
          }
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Download failed with status: ${response.statusCode}');
      }

      bytes = Uint8List.fromList(response.data!);

      final downloader = AdaptiveFileDownload(
        onProgress: (p) => onProgress?.call(0.5 + (p * 0.5)),
        onDownloadStarted: () => onProgress?.call(0.5),
        onDone: () => onProgress?.call(1.0),
        onError: (e) => throw Exception('Save error: $e'),
      );

      await downloader.downloadFile(bytes: bytes, fileName: fileName);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
