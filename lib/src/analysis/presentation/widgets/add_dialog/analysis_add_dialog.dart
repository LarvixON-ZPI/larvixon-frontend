import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_upload_cubit/analysis_upload_cubit.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/dialog_utils.dart';

class LarvaVideoAddForm extends StatefulWidget {
  const LarvaVideoAddForm({super.key});

  static Future<void> showUploadLarvaVideoDialog(
    BuildContext context,
    AnalysisListCubit videoListCubit,
  ) {
    return DialogUtils.showScaleDialog(
      barrierLabel: "Upload video dialog",
      context: context,
      title: Text(
        context.translate.uploadNewVideo,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      description: Text(
        context.translate.uploadVideoDescription,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      child: BlocProvider.value(
        value: videoListCubit,
        child: const LarvaVideoAddForm(),
      ),
    );
  }

  @override
  State<LarvaVideoAddForm> createState() => _LarvaVideoAddFormState();
}

class _LarvaVideoAddFormState extends State<LarvaVideoAddForm> {
  Uint8List? _fileBytes;
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  bool _fileSizeError = false;
  bool _isReading = false;
  double _readProgress = 0.0;

  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AdaptiveFilePicker _filePicker;

  /// Max 3 GB
  static const int _maxFileSizeBytes = 3 * 1024 * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    _filePicker = AdaptiveFilePicker(
      onFilePicked: _onFileStart,
      onProgress: _onProgress,
      onDone: _onFileReadDone,
      onError: (_) => _onFileReadDone(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _filePicker.cancel();
    super.dispose();
  }

  String _formatMaximumFileSize(int bytes) {
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;

    if (bytes < kb) {
      return '${bytes.toStringAsFixed(0)} B';
    } else if (bytes < mb) {
      return '${(bytes / kb).toStringAsFixed(2)} KB';
    } else if (bytes < gb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / gb).toStringAsFixed(2)} GB';
    }
  }

  void _onFileStart() => setState(() {
    _isReading = true;
    _readProgress = 0.0;
  });

  void _onFileReadDone() => setState(() {
    _isReading = false;
    _readProgress = 0.0;
  });

  void _onProgress(double progress) => setState(() {
    _readProgress = progress;
  });

  void _clearFileError() => _fileSizeError = false;

  void _clearFileSelection() {
    _fileBytes = null;
    _fileName = null;
    _filePath = null;
    _fileSize = null;
  }

  bool _validateFileSize(int size) => size <= _maxFileSizeBytes;

  Future<void> _pickFile() async {
    _clearFileError();
    _fileSizeError = false;
    final result = await _filePicker.pickFile();
    if (!mounted || result == null) return;

    final size = result.size ?? result.bytes.length;
    if (!_validateFileSize(size)) {
      setState(() {
        _fileSizeError = true;
        _clearFileSelection();
        _fileSize = size;
      });
      return;
    }

    setState(() {
      _fileBytes = result.bytes;
      _fileName = result.name;
      _filePath = result.path;
      _fileSize = size;
      _fileSizeError = false;
    });
  }

  void _cancelRead() {
    _filePicker.cancel();
    _onFileReadDone();
  }

  bool _isBusy(AnalysisUploadState state) =>
      _isReading ||
      state.status == VideoUploadStatus.uploading ||
      state.status == VideoUploadStatus.success;

  bool _canUpload(AnalysisUploadState state) {
    final isTooLarge = _fileSize != null && _fileSize! > _maxFileSizeBytes;
    return _fileBytes != null && !_isBusy(state) && !isTooLarge;
  }

  void _uploadFile(BuildContext context) {
    if (_fileBytes == null ||
        _fileName == null ||
        _fileSizeError ||
        !_formKey.currentState!.validate()) {
      return;
    }

    context.read<AnalysisUploadCubit>().uploadVideo(
      bytes: _fileBytes!,
      filename: _fileName!,
      title: _titleController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalysisUploadCubit(repository: context.read()),
      child: BlocConsumer<AnalysisUploadCubit, AnalysisUploadState>(
        listener: _onUploadStateChange,
        builder: (context, state) {
          final canUpload = _canUpload(state);
          final isUploading = state.status == VideoUploadStatus.uploading;
          final progress = state.uploadProgress;

          return Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                _TitleField(
                  controller: _titleController,
                  maximumFileSizeString: _formatMaximumFileSize(
                    _maxFileSizeBytes,
                  ),
                ),
                _FilePickerButton(
                  isReading: _isReading,
                  fileName: _fileName,
                  filePath: _filePath,
                  fileSizeError: _fileSizeError,
                  onPickFile: _pickFile,
                  progress: _readProgress,
                ),
                _ActionButtons(
                  isReading: _isReading,
                  isUploading: isUploading,
                  canUpload: canUpload,
                  progress: progress,
                  onCancel: _cancelRead,
                  onUpload: () => _uploadFile(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onUploadStateChange(BuildContext context, AnalysisUploadState state) {
    if (state.status == VideoUploadStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? context.translate.unknownError),
        ),
      );
    } else if (state.status == VideoUploadStatus.success) {
      context.read<AnalysisListCubit>().fetchNewlyUploadedAnalysis(
        id: state.uploadedVideoId!,
      );
      if (mounted) Navigator.of(context).pop();
    }
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.controller,
    required this.maximumFileSizeString,
  });
  final TextEditingController controller;
  final String maximumFileSizeString;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Text(
          context.translate.maximumFileSize(maximumFileSizeString),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: context.translate.enterTitle,
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            filled: true,
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? context.translate.fieldIsRequired
              : null,
        ),
      ],
    );
  }
}

class _FilePickerButton extends StatelessWidget {
  const _FilePickerButton({
    required this.isReading,
    required this.fileName,
    required this.filePath,
    required this.fileSizeError,
    required this.onPickFile,
    this.progress,
  });

  final bool isReading;
  final bool fileSizeError;
  final String? fileName;
  final String? filePath;
  final double? progress;
  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isReading
            ? _LoadingFileProgressSection(progress: progress)
            : ElevatedButton.icon(
                key: ValueKey('pickFile$fileSizeError'),
                onPressed: isReading ? null : onPickFile,
                style: fileSizeError
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.errorContainer,
                      )
                    : null,
                icon: fileSizeError
                    ? Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      )
                    : const Icon(Icons.upload_file),
                label: Text(
                  fileSizeError
                      ? context.translate.fileSizeError
                      : (fileName ?? filePath ?? context.translate.selectVideo),
                  style: TextStyle(
                    color: fileSizeError
                        ? Theme.of(context).colorScheme.onErrorContainer
                        : null,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isReading,
    required this.isUploading,
    required this.canUpload,
    required this.onCancel,
    required this.onUpload,
    this.progress = 0,
  });

  final bool isReading;
  final bool isUploading;
  final bool canUpload;
  final VoidCallback onCancel;
  final VoidCallback onUpload;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
            ),
            onPressed: (isReading && !kIsWeb)
                ? onCancel
                : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
            label: Text(
              (isReading && !kIsWeb)
                  ? context.translate.cancelFileUpload
                  : context.translate.cancel,
              key: ValueKey(isReading),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: ElevatedButton.icon(
            iconAlignment: IconAlignment.start,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: canUpload ? onUpload : null,
            icon: _UploadIcon(isUploading: isUploading),
            label: _UploadText(isUploading: isUploading, progress: progress),
          ),
        ),
      ],
    );
  }
}

class _LoadingFileProgressSection extends StatelessWidget {
  final double? progress;

  const _LoadingFileProgressSection({this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              value: (kIsWeb || progress == null) ? null : progress,
              minHeight: 20,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  (progress == null || kIsWeb)
                      ? context.translate.loadingFile
                      : '${(progress! * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UploadText extends StatelessWidget {
  const _UploadText({required this.isUploading, this.progress = 0});
  final bool isUploading;
  final double progress;

  @override
  Widget build(BuildContext context) {
    if (!isUploading) {
      return Text(
        context.translate.upload,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final percent = (progress * 100).clamp(0, 100).toInt();

    return SizedBox(
      width: 60,
      child: Text(
        '$percent%',
        textAlign: TextAlign.center,
        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      ),
    );
  }
}

class _UploadIcon extends StatefulWidget {
  final bool isUploading;
  const _UploadIcon({this.isUploading = false});

  @override
  State<_UploadIcon> createState() => _UploadIconState();
}

class _UploadIconState extends State<_UploadIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isUploading) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _UploadIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isUploading != widget.isUploading) {
      if (widget.isUploading) {
        _controller.repeat(reverse: true);
      } else {
        _controller.animateTo(1.0, duration: const Duration(milliseconds: 200));
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: const Icon(Icons.cloud_upload),
    );
  }
}
