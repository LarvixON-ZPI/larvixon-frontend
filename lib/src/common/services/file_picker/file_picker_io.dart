import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_base.dart';

class FilePickerImpl extends FilePickerBase {
  StreamSubscription<List<int>>? _readSub;

  @override
  Future<FilePickResult?> pickFile({FileType type = FileType.video}) async {
    final result = await FilePicker.platform.pickFiles(type: type);
    if (result == null || result.files.isEmpty) return null;
    final picked = result.files.first;
    if (picked.path == null) return null;

    onFilePicked?.call();

    final file = File(picked.path!);
    final total = await file.length();
    final builder = BytesBuilder(copy: false);
    int read = 0;

    final completer = Completer<FilePickResult?>();
    try {
      _readSub = file.openRead().listen(
        (chunk) {
          builder.add(chunk);
          read += chunk.length;
          onProgress?.call(total > 0 ? read / total : 0.0);
        },
        onDone: () {
          final bytes = Uint8List.fromList(builder.toBytes());
          onProgress?.call(1.0);
          onDone?.call();
          completer.complete(
            FilePickResult(bytes: bytes, name: picked.name, path: picked.path),
          );
        },
        onError: (e) {
          onError?.call(e);
          completer.completeError(e);
        },
        cancelOnError: true,
      );
    } catch (e) {
      onError?.call(e);
      completer.completeError(e);
    }
    return completer.future;
  }

  @override
  void cancel() {
    _readSub?.cancel();
    _readSub = null;
  }
}
