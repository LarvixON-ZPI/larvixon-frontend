import 'dart:typed_data';
import 'package:larvixon_frontend/src/common/services/file_download/file_download_stub.dart'
    if (dart.library.io) 'package:larvixon_frontend/src/common/services/file_download/file_download_io.dart'
    if (dart.library.html) 'package:larvixon_frontend/src/common/services/file_download/file_download_web.dart';

class AdaptiveFileDownload {
  void Function(double progress)? onProgress;
  void Function(Object error)? onError;
  void Function()? onDownloadStarted;
  void Function()? onDone;

  final FileDownloadImpl _downloader;

  AdaptiveFileDownload({
    this.onProgress,
    this.onError,
    this.onDownloadStarted,
    this.onDone,
  }) : _downloader = FileDownloadImpl() {
    _downloader.onProgress = onProgress;
    _downloader.onError = onError;
    _downloader.onDownloadStarted = onDownloadStarted;
    _downloader.onDone = onDone;
  }

  Future<void> downloadFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    return _downloader.downloadFile(bytes: bytes, fileName: fileName);
  }

  void cancel() {
    _downloader.cancel();
  }
}
