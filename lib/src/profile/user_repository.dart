import 'package:larvixon_frontend/src/profile/user.dart';

import 'user_datasource.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository({required this.dataSource});

  Future<User> getUserProfile() async {
    print('Fetching user profile from repository');
    final data = await dataSource.getUserProfile();
    return User.fromJson(data);
  }
}
