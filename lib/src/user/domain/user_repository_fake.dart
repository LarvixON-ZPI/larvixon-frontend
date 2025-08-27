import '../user.dart';
import 'user_repository.dart';

class UserRepositoryFake implements UserRepository {
  User _user = User(
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    dateJoined: DateTime.now(),
    bio: 'This is a test user.',
    phoneNumber: '123-456-7890',
    organization: 'Test Org',
  );

  @override
  Future<User> getUserProfile() {
    return Future.value(_user);
  }

  @override
  Future<User> updateUserProfile({required User user}) {
    _user = user;
    return Future.value(_user);
  }
}
