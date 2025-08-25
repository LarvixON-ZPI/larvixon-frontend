import 'dart:async';

import 'package:larvixon_frontend/core/api_client.dart';

import '../../core/constants/endpoints_user.dart';

class UserDataSource {
  final ApiClient apiClient;

  UserDataSource(this.apiClient);

  FutureOr<Map<String, dynamic>> getUserProfile() async {
    final response = await apiClient.dio.get(UserEndpoints.profile);
    print('User profile fetched: ${response.data}');
    return response.data;
  }

  FutureOr<Map<String, dynamic>> updateUserProfile({
    required String? firstName,
    required String? lastName,
    required String? email,
  }) async {
    final response = await apiClient.dio.put(
      UserEndpoints.profile,
      data: {
        'first_name': firstName ?? '',
        'last_name': lastName ?? '',
        'email': email ?? '',
      },
    );
    return response.data;
  }

  FutureOr<Map<String, dynamic>> updateUserProfileDetails({
    required String? bio,
    required String? organization,
    required String? phoneNumber,
  }) async {
    final response = await apiClient.dio.put(
      UserEndpoints.profileDetails,
      data: {
        'bio': bio ?? '',
        'organization': organization ?? '',
        'phone_number': phoneNumber ?? '',
      },
    );
    return response.data;
  }
}
