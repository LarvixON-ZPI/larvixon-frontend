part of 'analysis_upload_cubit.dart';

enum VideoUploadStatus { initial, uploading, success, error }

class AnalysisUploadState extends Equatable {
  final VideoUploadStatus status;
  final String? errorMessage;
  final int? uploadedVideoId;

  const AnalysisUploadState({
    this.status = VideoUploadStatus.initial,
    this.errorMessage,
    this.uploadedVideoId,
  });

  @override
  List<Object?> get props => [status, errorMessage, uploadedVideoId];

  AnalysisUploadState copyWith({
    VideoUploadStatus? status,
    String? errorMessage,
    int? uploadedVideoId,
  }) {
    return AnalysisUploadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedVideoId: uploadedVideoId ?? this.uploadedVideoId,
    );
  }
}
