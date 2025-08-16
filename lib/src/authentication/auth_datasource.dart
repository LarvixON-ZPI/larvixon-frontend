import 'package:larvixon_frontend/core/constants/endpoints_auth.dart';

import '../../core/api_client.dart';

class AuthDataSource {
  final ApiClient apiClient;

  AuthDataSource(this.apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiClient.dio.post(
      AuthEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await apiClient.dio.post(
      AuthEndpoints.refreshToken,
      data: {'refresh': refreshToken},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
    String passwordConfirm,
    String firstName,
    String lastName,
  ) async {
    final response = await apiClient.dio.post(
      AuthEndpoints.register,
      data: {
        "username": username,
        "email": email,
        "password": password,
        "password_confirm": passwordConfirm,
        "first_name": firstName,
        "last_name": lastName,
      },
    );
    return response.data;
  }
}
