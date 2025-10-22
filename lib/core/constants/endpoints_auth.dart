import 'package:larvixon_frontend/core/constants/api_base.dart';

class AuthEndpoints {
  static const String login = "${ApiBase.baseUrl}/accounts/login/";
  static const String register = "${ApiBase.baseUrl}/accounts/register/";
  static const String changePassword =
      "${ApiBase.baseUrl}/accounts/change-password/";
  static const String logout = "${ApiBase.baseUrl}/accounts/logout/";
  static const String refreshToken = "${ApiBase.baseUrl}/token/refresh/";
  static const String verifyToken = "${ApiBase.baseUrl}/token/verify/";
}
