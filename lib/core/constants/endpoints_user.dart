import 'api_base.dart';

class UserEndpoints {
  static const String profile = '${ApiBase.baseUrl}/accounts/profile/';
  static const String profileDetails =
      '${ApiBase.baseUrl}/accounts/profile/details/';
  static const String changePassword =
      "${ApiBase.baseUrl}/accounts/password/change/";
  static const String profileStats =
      "${ApiBase.baseUrl}/accounts/profile/stats/";
}
