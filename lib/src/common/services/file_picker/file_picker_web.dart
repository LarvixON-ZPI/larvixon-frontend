// file_picker_impl.dart (Web-specific)
import 'dart:async';
import 'dart:html' as html;

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_base.dart';

class FilePickerImpl extends FilePickerBase {
  @override
  Future<FilePickResult?> pickFile({FileType type = FileType.video}) async {
    onFilePicked?.call();

    final completer = Completer<FilePickResult?>();
    final input = html.FileUploadInputElement();
    input.accept = _getMimeTypes(type);
    input.multiple = false;

    input.onChange.listen((event) async {
      final files = input.files;
      if (files == null || files.isEmpty) {
        completer.complete(null);
        onDone?.call();
        return;
      }

      final file = files[0];
      print(file);
      completer.complete(
        FilePickResult(
          streamFactory: ({CancelToken? cancelToken}) =>
              _createMemoryEfficientStream(file, cancelToken: cancelToken),
          name: file.name,
          size: file.size,
          nativeFile: file,
        ),
      );
    });

    input.click();
    return completer.future;
  }

  Stream<List<int>> _createMemoryEfficientStream(
    html.File file, {
    CancelToken? cancelToken,
    int chunkSize = 64 * 1024,
  }) async* {
    int offset = 0;
    int chunkCount = 0;

    while (offset < file.size) {
      if (cancelToken?.isCancelled ?? false) break;

      // Allow GC to work between chunks
      if (chunkCount % 20 == 0) {
        await Future.delayed(const Duration(milliseconds: 1));
      }

      final end = (offset + chunkSize > file.size)
          ? file.size
          : offset + chunkSize;
      final blob = file.slice(offset, end);

      final chunk = await _readBlob(blob);
      yield chunk;

      offset = end;
      chunkCount++;
    }

    onDone?.call();
  }

  Future<Uint8List> _readBlob(html.Blob blob) async {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();

    reader.onLoad.listen((e) {
      final result = reader.result;
      if (result is Uint8List) {
        completer.complete(result);
      } else if (result is ByteBuffer) {
        completer.complete(Uint8List.view(result));
      } else {
        completer.completeError(Exception('Unexpected result type'));
      }
    });

    reader.onError.listen((e) {
      completer.completeError(Exception('Failed to read blob'));
    });

    reader.readAsArrayBuffer(blob);
    return completer.future;
  }

  String _getMimeTypes(FileType type) {
    switch (type) {
      case FileType.video:
        return 'video/*';
      case FileType.image:
        return 'image/*';
      case FileType.any:
      default:
        return '*/*';
    }
  }

  @override
  void cancel() {
    // Implementation depends on your needs
  }
}
