import 'package:file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker_stub.dart'
    if (dart.library.io) 'package:larvixon_frontend/src/common/services/file_picker/file_picker_io.dart'
    if (dart.library.html) 'package:larvixon_frontend/src/common/services/file_picker/file_picker_web.dart';

class AdaptiveFilePicker {
  void Function(double progress)? onProgress;
  void Function(Object error)? onError;
  void Function()? onFilePicked;
  void Function()? onDone;

  final FilePickerImpl _filePicker;
  AdaptiveFilePicker({
    this.onProgress,
    this.onError,
    this.onFilePicked,
    this.onDone,
  }) : _filePicker = FilePickerImpl() {
    _filePicker.onProgress = onProgress;
    _filePicker.onError = onError;
    _filePicker.onFilePicked = onFilePicked;
    _filePicker.onDone = onDone;
  }
  void cancel() {
    _filePicker.cancel();
  }

  Future<FilePickResult?> pickFile({FileType type = FileType.video}) async {
    return _filePicker.pickFile(type: type);
  }
}
