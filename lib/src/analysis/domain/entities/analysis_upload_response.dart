class AnalysisUploadResponse {
  final int id;
  final String message;
  AnalysisUploadResponse({required this.id, required this.message});
  factory AnalysisUploadResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisUploadResponse(
      id: json['analysis_id'],
      message: json['message'],
    );
  }
}
