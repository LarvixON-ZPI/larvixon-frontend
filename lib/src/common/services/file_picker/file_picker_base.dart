import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FilePickResult {
  final Uint8List bytes;
  final String name;
  final String? path;
  final int? size;
  const FilePickResult({
    required this.bytes,
    required this.name,
    this.path,
    this.size,
  });
}

abstract class FilePickerBase {
  void Function(double progress)? onProgress;
  void Function(Object error)? onError;
  void Function()? onFilePicked;
  void Function()? onDone;

  void cancel() {}

  Future<FilePickResult?> pickFile({FileType type = FileType.video});
}
