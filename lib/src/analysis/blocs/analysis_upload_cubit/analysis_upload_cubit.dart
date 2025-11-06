import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

part 'analysis_upload_state.dart';

class AnalysisUploadCubit extends Cubit<AnalysisUploadState> {
  final AnalysisRepository repository;
  AnalysisUploadCubit({required this.repository})
    : super(const AnalysisUploadState());

  Future<void> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) async {
    emit(
      state.copyWith(status: VideoUploadStatus.uploading, uploadProgress: 0.0),
    );
    final result = await repository
        .uploadVideo(
          bytes: bytes,
          filename: filename,
          title: title,
          onProgress: (progress) {
            Future.microtask(() {
              emit(state.copyWith(uploadProgress: progress));
            });
          },
        )
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
