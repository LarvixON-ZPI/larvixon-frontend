part of 'video_upload_cubit.dart';

enum VideoUploadStatus { initial, uploading, success, error }

class VideoUploadState extends Equatable {
  final VideoUploadStatus status;
  final String? errorMessage;
  final int? uploadedVideoId;

  const VideoUploadState({
    this.status = VideoUploadStatus.initial,
    this.errorMessage,
    this.uploadedVideoId,
  });

  @override
  List<Object?> get props => [status, errorMessage, uploadedVideoId];

  VideoUploadState copyWith({
    VideoUploadStatus? status,
    String? errorMessage,
    int? uploadedVideoId,
  }) {
    return VideoUploadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedVideoId: uploadedVideoId ?? this.uploadedVideoId,
    );
  }
}
