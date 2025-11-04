import 'dart:typed_data';
import 'file_download_base.dart';

class FileDownloadImpl implements FileDownloadBase {
  @override
  void Function(double progress)? onProgress;

  @override
  void Function(Object error)? onError;

  @override
  void Function()? onDownloadStarted;

  @override
  void Function()? onDone;

  @override
  Future<void> downloadFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    throw UnimplementedError('File download not supported on this platform');
  }

  @override
  void cancel() {}
}
