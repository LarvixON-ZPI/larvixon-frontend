import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_base.dart';

class FilePickerImpl extends FilePickerBase {
  @override
  Future<FilePickResult?> pickFile({FileType type = FileType.video}) async {
    onFilePicked?.call();
    final result = await FilePicker.platform.pickFiles(
      type: type,
      withData: true,
      onFileLoading: (status) {
        if (status == FilePickerStatus.done) {
          onFilePicked?.call();
        }
      },
    );
    if (result == null || result.files.isEmpty) {
      onDone?.call();
      return null;
    }
    final picked = result.files.first;
    final bytes = picked.bytes;
    if (bytes == null) {
      onDone?.call();
      return null;
    }
    onProgress?.call(1.0);
    onDone?.call();
    return FilePickResult(bytes: bytes, name: picked.name);
  }
}
