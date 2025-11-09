import 'package:dio/dio.dart';

class FilePickResult {
  final Stream<List<int>> Function({CancelToken? cancelToken}) streamFactory;
  final String name;
  final String? path;
  final int? size;
  final dynamic nativeFile;

  const FilePickResult({
    required this.streamFactory,
    required this.name,
    this.path,
    this.size,
    this.nativeFile,
  });

  Stream<List<int>> get stream => streamFactory();
}
