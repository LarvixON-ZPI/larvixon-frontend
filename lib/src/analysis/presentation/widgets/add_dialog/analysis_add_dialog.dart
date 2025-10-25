import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_upload_cubit/analysis_upload_cubit.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_picker.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class LarvaVideoAddForm extends StatefulWidget {
  const LarvaVideoAddForm({super.key});

  @override
  State<LarvaVideoAddForm> createState() => _LarvaVideoAddFormState();

  static Future<void> showUploadLarvaVideoDialog(
    BuildContext context,
    AnalysisListCubit videoListCubit,
  ) {
    return showDialog(
      barrierColor: Colors.black.withOpacity(0.2),
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: BlocProvider.value(
                value: videoListCubit,
                child: const LarvaVideoAddForm(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LarvaVideoAddFormState extends State<LarvaVideoAddForm> {
  Uint8List? _fileBytes;
  String? _fileName;
  String? _filePath;
  bool _isReading = false;
  double _readProgress = 0.0;
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AdaptiveFilePicker _filePicker;

  @override
  void dispose() {
    _titleController.dispose();
    try {
      _filePicker.cancel();
    } catch (_) {}
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _filePicker = AdaptiveFilePicker(
      onDone: () {
        if (!mounted) return;
        setState(() {
          _isReading = false;
          _readProgress = 0.0;
        });
      },
      onError: (e) {
        if (!mounted) return;
        setState(() {
          _isReading = false;
          _readProgress = 0.0;
        });
      },
      onFilePicked: () {
        if (!mounted) return;
        setState(() {
          _isReading = true;
          _readProgress = 0.0;
        });
      },
      onProgress: (progress) {
        if (!mounted) return;
        setState(() {
          _readProgress = progress;
        });
      },
    );
  }

  void _pickFile() async {
    final result = await _filePicker.pickFile();
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _fileBytes = result.bytes;
        _fileName = result.name;
        _filePath = result.path;
      });
    }
  }

  void _cancelRead() {
    _filePicker.cancel();
    if (!mounted) return;
    setState(() {
      _isReading = false;
      _readProgress = 0.0;
    });
  }

  void _uploadFile(BuildContext context, GlobalKey<FormState> formKey) {
    if (_fileBytes != null &&
        _fileName != null &&
        formKey.currentState?.validate() == true) {
      context.read<AnalysisUploadCubit>().uploadVideo(
        bytes: _fileBytes!,
        filename: _fileName!,
        title: _titleController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalysisUploadCubit(repository: context.read()),
      child: BlocConsumer<AnalysisUploadCubit, AnalysisUploadState>(
        listener: (context, state) {
          if (state.status == VideoUploadStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? context.translate.unknownError,
                ),
              ),
            );
          }
          if (state.status == VideoUploadStatus.success) {
            context.read<AnalysisListCubit>().fetchNewlyUploadedAnalysis(
              id: state.uploadedVideoId!,
            );
            if (!mounted) return;
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final canUpload = _canUpload(state);
          final isUploading = state.status == VideoUploadStatus.uploading;

          return CustomCard(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            title: Text(context.translate.uploadNewVideo),
            description: Text(context.translate.uploadVideoDescription),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: context.translate.enterTitle,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.translate.fieldIsRequired;
                      }
                      return null;
                    },
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 150),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      child: _isReading
                          ? _UploadProgressSection(
                              progress: _readProgress,
                              onCancel: _cancelRead,
                            )
                          : ElevatedButton.icon(
                              key: const ValueKey('pickFile'),
                              onPressed: _isReading ? null : _pickFile,
                              icon: const Icon(Icons.upload_file),
                              label: Text(
                                _fileBytes != null
                                    ? context.translate.selectedFile(
                                        _fileName ?? _filePath ?? '',
                                      )
                                    : context.translate.selectVideo,
                              ),
                            ),
                    ),
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          label: Text(context.translate.cancel),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 2,
                        child: ElevatedButton.icon(
                          iconAlignment: IconAlignment.start,
                          onPressed: canUpload
                              ? null
                              : () => _uploadFile(context, _formKey),
                          icon: _UploadIcon(isUploading: isUploading),
                          label: _UploadText(isUploading: isUploading),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _canUpload(AnalysisUploadState state) {
    return _fileBytes == null ||
        _isReading ||
        state.status == VideoUploadStatus.uploading;
  }
}

class _UploadProgressSection extends StatelessWidget {
  final double? progress;
  final VoidCallback? onCancel;

  const _UploadProgressSection({this.progress, this.onCancel});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || progress == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(context.translate.loadingFile),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            LinearProgressIndicator(value: progress, minHeight: 20),
            Positioned.fill(
              child: Center(
                child: Text(
                  '${(progress! * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel),
              label: Text(context.translate.cancelFileUpload),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UploadText extends StatelessWidget {
  const _UploadText({required this.isUploading});
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final label = isUploading
        ? context.translate.uploading
        : context.translate.upload;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(label, key: ValueKey(label)),
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
      duration: const Duration(seconds: 1),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _UploadIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUploading) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: const Icon(Icons.cloud_upload),
        );
      },
    );
  }
}
