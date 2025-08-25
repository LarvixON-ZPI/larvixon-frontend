import 'package:larvixon_frontend/src/profile/user.dart';

import 'user_datasource.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository({required this.dataSource});

  Future<User> getUserProfile() async {
    final data = await dataSource.getUserProfile();
    return User.fromJson(data);
  }

  Future<User> updateUserProfile({required User user}) async {
    final data = await dataSource.updateUserProfile(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
    );
    final dataDetails = await dataSource.updateUserProfileDetails(
      bio: user.bio,
      organization: user.organization,
      phoneNumber: user.phoneNumber,
    );
    return User.fromJson({...data, ...dataDetails});
  }
}
