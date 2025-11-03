import 'dart:typed_data';

abstract class FileDownloadBase {
  void Function(double progress)? onProgress;
  void Function(Object error)? onError;
  void Function()? onDownloadStarted;
  void Function()? onDone;

  Future<void> downloadFile({
    required Uint8List bytes,
    required String fileName,
  });

  void cancel();
}
