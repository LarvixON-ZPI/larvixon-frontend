import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_upload_cubit/analysis_upload_cubit.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';
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
  FilePickResult? _fileResult;
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  bool _fileSizeError = false;

  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AdaptiveFilePicker _filePicker;

  /// Max 3 GB
  static const int _maxFileSizeBytes = 3 * 1024 * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    _filePicker = AdaptiveFilePicker();
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

  void _clearFileSelection() {
    _fileResult = null;
    _fileName = null;
    _filePath = null;
    _fileSize = null;
  }

  bool _validateFileSize(int size) => size <= _maxFileSizeBytes;

  Future<void> _pickFile() async {
    _fileSizeError = false;
    final result = await _filePicker.pickFile();
    if (!mounted || result == null) return;

    final size = result.size;
    if (size == null) {
      setState(() {
        _fileSizeError = true;
        _clearFileSelection();
      });
      return;
    }

    if (!_validateFileSize(size)) {
      setState(() {
        _fileSizeError = true;
        _clearFileSelection();
        _fileSize = size;
      });
      return;
    }

    setState(() {
      _fileResult = result;
      _fileName = result.name;
      _filePath = result.path;
      _fileSize = size;
      _fileSizeError = false;
    });
  }

  void _cancelUploading(BuildContext context) {
    context.read<AnalysisUploadCubit>().cancelUpload();
    _formKey.currentState?.reset();
  }

  bool _isBusy(VideoUploadStatus status) =>
      status == VideoUploadStatus.uploading ||
      status == VideoUploadStatus.success;

  bool _canUpload(VideoUploadStatus status) {
    final isTooLarge = _fileSize != null && _fileSize! > _maxFileSizeBytes;
    return _fileResult != null && !_isBusy(status) && !isTooLarge;
  }

  void _uploadFile(BuildContext context) {
    if (_fileResult == null ||
        _fileName == null ||
        _fileSizeError ||
        !_formKey.currentState!.validate()) {
      return;
    }

    context.read<AnalysisUploadCubit>().uploadVideo(
      fileResult: _fileResult!,
      title: _titleController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalysisUploadCubit(repository: context.read()),
      child: BlocListener<AnalysisUploadCubit, AnalysisUploadState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onUploadStateChange,
        child: Form(
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
              BlocSelector<
                AnalysisUploadCubit,
                AnalysisUploadState,
                ({VideoUploadStatus status, double progress})
              >(
                selector: (state) =>
                    (status: state.status, progress: state.uploadProgress),
                builder: (context, state) {
                  final (status: status, progress: progress) = state;
                  final isUploading = status == VideoUploadStatus.uploading;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: SizedBox(
                      key: ValueKey(isUploading),
                      height: 48,
                      child: isUploading
                          ? _UploadProgressSection(progress: progress)
                          : _FilePickerButton(
                              fileName: _fileName,
                              filePath: _filePath,
                              fileSizeError: _fileSizeError,
                              onPickFile: _pickFile,
                            ),
                    ),
                  );
                },
              ),
              BlocSelector<AnalysisUploadCubit, AnalysisUploadState, String?>(
                selector: (state) => state.errorMessage,
                builder: (context, message) {
                  return _ErrorSection(message: message);
                },
              ),
              BlocSelector<
                AnalysisUploadCubit,
                AnalysisUploadState,
                VideoUploadStatus
              >(
                selector: (state) => state.status,
                builder: (context, status) {
                  final canUpload = _canUpload(status);
                  return _ActionButtons(
                    status: status,
                    canUpload: canUpload,
                    onCancelUploading: _cancelUploading,
                    onUpload: () => _uploadFile(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onUploadStateChange(BuildContext context, AnalysisUploadState state) {
    if (state.status == VideoUploadStatus.success) {
      context.read<AnalysisListCubit>().fetchNewlyUploadedAnalysis(
        id: state.uploadedVideoId!,
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      child: message == null
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey(message),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
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
    required this.fileName,
    required this.filePath,
    required this.fileSizeError,
    required this.onPickFile,
  });

  final bool fileSizeError;
  final String? fileName;
  final String? filePath;
  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
      child: ElevatedButton.icon(
        key: ValueKey('pickFile$fileSizeError'),
        onPressed: onPickFile,
        style: fileSizeError
            ? ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
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
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    this.status = VideoUploadStatus.initial,
    required this.canUpload,
    required this.onCancelUploading,
    required this.onUpload,
  });

  final VideoUploadStatus status;

  final bool canUpload;
  final void Function(BuildContext context) onCancelUploading;
  final VoidCallback onUpload;
  bool get isUploading => status == VideoUploadStatus.uploading;
  bool get isSuccess => status == VideoUploadStatus.success;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _CancelButton(
            isUploading: isUploading,
            onCancelUploading: onCancelUploading,
          ),
        ),
        Flexible(
          flex: 2,
          child: _UploadButton(
            isSuccess: isSuccess,
            canUpload: canUpload,
            isUploading: isUploading,
            onUpload: onUpload,
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({
    required this.isUploading,
    required this.onCancelUploading,
  });

  final bool isUploading;
  final void Function(BuildContext context) onCancelUploading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isUploading
            ? Colors.red.shade800
            : Colors.grey.shade800,
      ),
      onPressed: () {
        if (isUploading) {
          onCancelUploading.call(context);
        } else if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      icon: const Icon(Icons.close, color: Colors.white),
      label: Text(
        isUploading
            ? context.translate.cancelFileUpload
            : context.translate.cancel,
        key: ValueKey(isUploading),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.canUpload,
    required this.isUploading,
    required this.onUpload,
    this.isSuccess = false,
  });

  final bool canUpload;
  final bool isUploading;
  final VoidCallback onUpload;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final targetColor = isSuccess
        ? Colors.green.shade800
        : Colors.blue.shade800;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: targetColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        iconAlignment: IconAlignment.start,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: (canUpload && !isSuccess)
              ? Colors.transparent
              : null,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: (canUpload && !isSuccess) ? onUpload : null,
        icon: _UploadIcon(isUploading: isUploading, isSuccess: isSuccess),
        label: _UploadText(isUploading: isUploading, isSuccess: isSuccess),
      ),
    );
  }
}

class _UploadProgressSection extends StatelessWidget {
  final double? progress;

  const _UploadProgressSection({this.progress});

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
              value: progress,
              minHeight: 20,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  progress == null
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
  const _UploadText({required this.isUploading, this.isSuccess = false});
  final bool isUploading;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Text(
      _getText(context),
      textAlign: TextAlign.center,
      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
    );
  }

  String _getText(BuildContext context) {
    final String text = isSuccess
        ? context.translate.success
        : isUploading
        ? context.translate.uploading
        : context.translate.upload;
    return text;
  }
}

class _UploadIcon extends StatefulWidget {
  final bool isUploading;
  final bool isSuccess;
  const _UploadIcon({this.isUploading = false, this.isSuccess = false});

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
        _controller.stop();
        _controller.animateTo(1.0, duration: const Duration(milliseconds: 200));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeInBack,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: widget.isSuccess
            ? const Icon(Icons.check_circle, key: ValueKey('success'))
            : const Icon(Icons.cloud_upload, key: ValueKey('upload')),
      ),
    );
  }
}
