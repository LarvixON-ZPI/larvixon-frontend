import 'dart:typed_data';

class FilePickResult {
  final Uint8List bytes;
  final String name;
  final String? path;
  const FilePickResult({required this.bytes, required this.name, this.path});
}

abstract class FilePickerBase {
  void Function(double progress)? onProgress;
  void Function(Object error)? onError;
  void Function()? onFilePicked;
  void Function()? onDone;

  void cancel() {}

  Future<FilePickResult?> pickFile();
}
