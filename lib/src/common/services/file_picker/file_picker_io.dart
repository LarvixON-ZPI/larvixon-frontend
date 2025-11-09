import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_base.dart';

class FilePickerImpl extends FilePickerBase {
  StreamSubscription<List<int>>? _readSub;

  @override
  Future<FilePickResult?> pickFile({FileType type = FileType.video}) async {
    onFilePicked?.call();

    final result = await FilePicker.platform.pickFiles(
      type: type,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) {
      onDone?.call();
      return null;
    }
    final picked = result.files.first;
    if (picked.path == null) return null;
    final file = File(picked.path!);
    final total = await file.length();

    Stream<List<int>> createStream({CancelToken? cancelToken}) {
      final controller = StreamController<List<int>>(
        onPause: () => _readSub?.pause(),
        onResume: () => _readSub?.resume(),
        onCancel: () => _readSub?.cancel(),
      );
      bool isCancelled = false;

      cancelToken?.whenCancel.then((_) {
        isCancelled = true;
        _readSub?.cancel();
        if (!controller.isClosed) {
          controller.close();
        }
      });

      _readSub?.cancel();
      _readSub = file.openRead().listen(
        (chunk) {
          if (isCancelled || (cancelToken?.isCancelled ?? false)) {
            _readSub?.cancel();
            if (!controller.isClosed) {
              controller.close();
            }
            return;
          }
          if (!controller.isClosed) {
            controller.add(chunk);
          }
        },
        onDone: () {
          if (!controller.isClosed) {
            controller.close();
          }
        },
        onError: (e) {
          if (!controller.isClosed) {
            controller.addError(e);
            controller.close();
          }
        },
        cancelOnError: true,
      );

      return controller.stream;
    }

    return FilePickResult(
      streamFactory: createStream,
      name: picked.name,
      size: total,
      path: picked.path,
      nativeFile: file,
    );
  }

  @override
  void cancel() {
    _readSub?.cancel();
    _readSub = null;
  }
}
