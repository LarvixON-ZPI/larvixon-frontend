part of 'analysis_upload_cubit.dart';

enum VideoUploadStatus { initial, uploading, success, error }

class AnalysisUploadState extends Equatable {
  final VideoUploadStatus status;
  final String? errorMessage;
  final int? uploadedVideoId;
  final double uploadProgress;

  const AnalysisUploadState({
    this.status = VideoUploadStatus.initial,
    this.uploadProgress = 0.0,
    this.errorMessage,
    this.uploadedVideoId,
  });

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    uploadedVideoId,
    uploadProgress,
  ];

  AnalysisUploadState copyWith({
    VideoUploadStatus? status,
    String? errorMessage,
    int? uploadedVideoId,
    double? uploadProgress,
  }) {
    return AnalysisUploadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedVideoId: uploadedVideoId ?? this.uploadedVideoId,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
