import 'dart:async';
import 'dart:typed_data';

import 'package:larvixon_frontend/core/api_client.dart';

class LarvaVideoDatasource {
  final ApiClient apiClient;

  LarvaVideoDatasource({required this.apiClient});

  Future<Map<String, dynamic>> fetchVideosIds() {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> fetchVideoDetailsById(int id) {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) {
    throw UnimplementedError();
  }

  Stream<Map<String, dynamic>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  }) async* {
    throw UnimplementedError();
  }
}

// abstract class LarvaVideoRepository {
//   Future<List<int>> fetchVideoIds();
//   Future<LarvaVideo> fetchVideoDetailsById(int id);
//   Future<List<LarvaVideo>> fetchVideosDetails();
//   Future<void> addVideo(LarvaVideo video);
//   Stream<LarvaVideo> watchVideoProgressById({
//     required int id,
//     Duration interval = const Duration(seconds: 5),
//   });
// }
