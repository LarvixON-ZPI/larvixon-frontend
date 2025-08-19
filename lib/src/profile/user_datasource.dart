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
}
