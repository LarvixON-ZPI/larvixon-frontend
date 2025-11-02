import 'dart:async';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart' show Failure;

import 'package:larvixon_frontend/src/user/domain/entities/user.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';

class UserRepositoryFake implements UserRepository {
  final StreamController<User> _userController = StreamController.broadcast();
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
  TaskEither<Failure, User> fetchUserProfile() {
    return TaskEither(() async {
      _userController.add(_user);
      return Right(_user);
    });
  }

  @override
  TaskEither<Failure, void> updateUserProfileDetails({
    String? phoneNumber,
    String? bio,
    String? org,
  }) {
    _user = _user.copyWith(
      bio: bio,
      phoneNumber: phoneNumber,
      organization: org,
    );
    fetchUserProfile().run();
    return TaskEither.right(null);
  }

  @override
  Stream<User> get userStream => _userController.stream;

  @override
  void dispose() {
    _userController.close();
  }

  @override
  TaskEither<Failure, void> updateUserProfilePhoto({
    required Uint8List bytes,
    required String fileName,
  }) {
    throw UnimplementedError();
  }

  @override
  TaskEither<Failure, void> updateUserProfileBasicInfo({
    required String firstName,
    required String lastName,
  }) {
    _user = _user.copyWith(firstName: firstName, lastName: lastName);
    fetchUserProfile().run();
    return TaskEither.right(null);
  }
}
