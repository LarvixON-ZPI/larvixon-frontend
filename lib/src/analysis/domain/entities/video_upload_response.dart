class VideoUploadResponse {
  final int id;
  final String message;
  VideoUploadResponse({required this.id, required this.message});
  factory VideoUploadResponse.fromJson(Map<String, dynamic> json) {
    return VideoUploadResponse(
      id: json['analysis_id'],
      message: json['message'],
    );
  }
}
