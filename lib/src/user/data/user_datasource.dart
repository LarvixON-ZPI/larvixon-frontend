import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/src/common/extensions/non_null_map.dart';
import 'package:larvixon_frontend/src/user/data/models/user_dto.dart';

import 'package:larvixon_frontend/core/constants/endpoints_user.dart';

class UserDataSource {
  final ApiClient apiClient;

  UserDataSource(this.apiClient);

  Future<UserProfileDTO> getUserProfile() async {
    final response = await apiClient.dio.get(UserEndpoints.profile);

    return UserProfileDTO.fromMap(response.data);
  }

  Future<UserProfileDTO> updateUserProfile({
    required UserProfileDTO dto,
  }) async {
    final response = await apiClient.dio.patch(
      UserEndpoints.profile,
      data: dto.toMap().toNonNull(),
    );

    return UserProfileDTO.fromMap(response.data);
  }

  Future<void> updateUserProfilePhoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'profile_picture': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    final response = await apiClient.dio.patch(
      UserEndpoints.profileDetails,
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );
  }

  Future<UserProfileDetailsDTO> updateUserProfileDetails({
    required UserProfileDetailsDTO profileDetails,
  }) async {
    final formData = FormData.fromMap(profileDetails.toMap());
    final response = await apiClient.dio.patch(
      UserEndpoints.profileDetails,
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );

    return UserProfileDetailsDTO.fromMap(response.data);
  }
}
