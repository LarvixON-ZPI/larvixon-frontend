import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';

part 'analysis_upload_state.dart';

class AnalysisUploadCubit extends Cubit<AnalysisUploadState> {
  final AnalysisRepository repository;
  CancelToken? _cancelToken;
  AnalysisUploadCubit({required this.repository})
    : super(const AnalysisUploadState());

  Future<void> uploadVideo({
    required FilePickResult fileResult,
    required String title,
  }) async {
    _cancelToken = CancelToken();
    const double lastProgress = 0.0;
    emit(
      state.copyWith(status: VideoUploadStatus.uploading, uploadProgress: 0.0),
    );
    int lastUpdateTime = 0;
    final result = await repository
        .uploadVideo(
          fileResult: fileResult,
          title: title,
          cancelToken: _cancelToken,
          onProgress: (progress) {
            final now = DateTime.now().millisecondsSinceEpoch;
            if (now - lastUpdateTime < 100) return;
            lastUpdateTime = now;

            Future.microtask(() {
              if ((_cancelToken?.isCancelled ?? false) || isClosed) return;
              emit(state.copyWith(uploadProgress: progress));
            });
          },
        )
        .run();
    if (_cancelToken?.isCancelled ?? false) return;
    if (isClosed) return;

    result.match(
      (failure) {
        if (failure is CanceledUploadFailure) {
          emit(
            state.copyWith(
              status: VideoUploadStatus.initial,
              // ignore: avoid_redundant_argument_values
              errorMessage: null,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: VideoUploadStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (response) => emit(
        state.copyWith(
          status: VideoUploadStatus.success,
          uploadedVideoId: response.id,
        ),
      ),
    );
  }

  Future<void> cancelUpload() async {
    if (state.status != VideoUploadStatus.uploading ||
        _cancelToken?.isCancelled == true) {
      return;
    }
    _cancelToken?.cancel('User cancelled upload');
    _cancelToken = null;
    emit(state.copyWith(status: VideoUploadStatus.initial, uploadProgress: 0));
    return;
  }

  @override
  Future<void> close() async {
    await cancelUpload();
    return super.close();
  }
}
