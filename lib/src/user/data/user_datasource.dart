import 'dart:async';

import 'package:larvixon_frontend/core/api_client.dart';
import 'package:larvixon_frontend/src/user/data/models/user_dto.dart';

import '../../../core/constants/endpoints_user.dart';

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
    final response = await apiClient.dio.put(
      UserEndpoints.profile,
      data: dto.toMap(),
    );

    return UserProfileDTO.fromMap(response.data);
  }

  Future<UserProfileDetailsDTO> updateUserProfileDetails({
    required UserProfileDetailsDTO profileDetails,
  }) async {
    final response = await apiClient.dio.put(
      UserEndpoints.profileDetails,
      data: profileDetails.toMap(),
    );

    return UserProfileDetailsDTO.fromMap(response.data);
  }
}
