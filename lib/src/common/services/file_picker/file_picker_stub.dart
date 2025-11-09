import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_base.dart';

class FilePickerImpl extends FilePickerBase {
  @override
  Future<FilePickResult?> pickFile({FileType type = FileType.video}) {
    throw Exception("Stub implementation");
  }
}
