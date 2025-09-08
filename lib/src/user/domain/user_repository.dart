import '../user.dart';

abstract class UserRepository {
  Future<User> getUserProfile();

  Future<User> updateUserProfile({required User user});
}
