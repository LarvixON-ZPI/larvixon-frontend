import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

part 'video_upload_state.dart';

class VideoUploadCubit extends Cubit<VideoUploadState> {
  final AnalysisRepository repository;
  VideoUploadCubit({required this.repository}) : super(VideoUploadState());

  Future<void> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) async {
    emit(state.copyWith(status: VideoUploadStatus.uploading));
    final result = await repository
        .uploadVideo(bytes: bytes, filename: filename, title: title)
        .run();

    result.match(
      (failure) => emit(
        state.copyWith(
          status: VideoUploadStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: VideoUploadStatus.success,
          uploadedVideoId: response.id,
        ),
      ),
    );
  }
}
