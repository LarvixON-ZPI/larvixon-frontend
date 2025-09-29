import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_upload_cubit/video_upload_cubit.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class LarvaVideoAddForm extends StatefulWidget {
  const LarvaVideoAddForm({super.key});

  @override
  State<LarvaVideoAddForm> createState() => _LarvaVideoAddFormState();
  static Future<void> showLarvaVideoDialog(
    BuildContext context,
    AnalysisListCubit videoListCubit,
  ) {
    return showDialog(
      barrierColor: Colors.black.withValues(alpha: 0.2),
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),

              child: BlocProvider.value(
                value: videoListCubit,
                child: LarvaVideoAddForm(),
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
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.first.name;
        _fileBytes = result.files.first.bytes;
      });
    }
  }

  void _uploadFile(BuildContext context, GlobalKey<FormState> formKey) {
    if (_fileBytes != null &&
        _fileName != null &&
        formKey.currentState?.validate() == true) {
      context.read<VideoUploadCubit>().uploadVideo(
        bytes: _fileBytes!,
        filename: _fileName!,
        title: _titleController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoUploadCubit(repository: context.read()),
      child: BlocConsumer<VideoUploadCubit, VideoUploadState>(
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
            context.read<AnalysisListCubit>().fetchNewlyUploadedVideo(
              id: state.uploadedVideoId!,
            );
            Future.delayed(const Duration(milliseconds: 500)).then((_) {});
            if (!mounted) return;
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final canUpload = _fileBytes == null;
          final isUploading = state.status == VideoUploadStatus.uploading;

          return CustomCard(
            color: Colors.transparent,
            title: context.translate.uploadNewVideo,

            description: context.translate.uploadVideoDescription,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hint: Text(context.translate.enterTitle),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.translate.fieldIsRequired;
                        }
                        return null;
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file),
                      label: Text(
                        _fileName != null
                            ? context.translate.selectedFile(_fileName!)
                            : context.translate.selectVideo,
                      ),
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            label: Text(context.translate.cancel),
                          ),
                        ),
                        Spacer(flex: 1),
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
            ],
          );
        },
      ),
    );
  }
}

class _UploadText extends StatefulWidget {
  const _UploadText({required this.isUploading});

  final bool isUploading;

  @override
  State<_UploadText> createState() => _UploadTextState();
}

class _UploadTextState extends State<_UploadText> {
  @override
  Widget build(BuildContext context) {
    final label = widget.isUploading
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
          child: Icon(Icons.cloud_upload),
        );
      },
    );
  }
}
