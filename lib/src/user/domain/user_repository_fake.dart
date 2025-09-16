import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart' show Failure;

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
  TaskEither<Failure, User> getUserProfile() {
    return TaskEither(() async => Right(_user));
  }

  @override
  TaskEither<Failure, User> updateUserProfile({required User user}) {
    _user = user;
    return TaskEither(() async => Right(_user));
  }
}
