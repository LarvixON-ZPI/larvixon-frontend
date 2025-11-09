import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';

abstract class FilePickerBase {
  void Function(double progress)? onProgress;
  void Function(Object error)? onError;
  void Function()? onFilePicked;
  void Function()? onDone;

  void cancel() {}

  Future<FilePickResult?> pickFile({FileType type = FileType.video});
}
