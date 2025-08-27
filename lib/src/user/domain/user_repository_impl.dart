import '../data/user_datasource.dart';
import '../user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<User> getUserProfile() async {
    final data = await dataSource.getUserProfile();
    return User.fromJson(data);
  }

  @override
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

    return User.fromJson({...data, 'profile': dataDetails});
  }
}
