import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:larvixon_frontend/src/common/services/file_download/file_download_base.dart';

class FileDownloadImpl implements FileDownloadBase {
  @override
  void Function(double progress)? onProgress;

  @override
  void Function(Object error)? onError;

  @override
  void Function()? onDownloadStarted;

  @override
  void Function()? onDone;

  bool _isCancelled = false;

  @override
  Future<void> downloadFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    _isCancelled = false;

    try {
      onDownloadStarted?.call();

      // Let user choose save location
      final savePath = await file_picker.FilePicker.platform.saveFile(
        dialogTitle: 'Save file',
        fileName: fileName,
      );

      if (savePath == null || _isCancelled) {
        return;
      }

      onProgress?.call(0.3);

      final file = File(savePath);

      // Write file in chunks for progress tracking
      final raf = await file.open(mode: FileMode.write);
      const chunkSize = 8192; // 8KB chunks
      int written = 0;

      for (int i = 0; i < bytes.length; i += chunkSize) {
        if (_isCancelled) {
          await raf.close();
          await file.delete();
          return;
        }

        final end = (i + chunkSize < bytes.length)
            ? i + chunkSize
            : bytes.length;
        await raf.writeFrom(bytes, i, end);
        written = end;

        onProgress?.call(0.3 + (written / bytes.length * 0.7));
      }

      await raf.close();

      onProgress?.call(1.0);
      onDone?.call();
    } catch (e) {
      if (!_isCancelled) {
        onError?.call(e);
      }
      rethrow;
    }
  }

  @override
  void cancel() {
    _isCancelled = true;
  }
}
