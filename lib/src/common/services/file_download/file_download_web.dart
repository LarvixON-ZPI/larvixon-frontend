// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

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

  @override
  Future<void> downloadFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  void cancel() {}
}
