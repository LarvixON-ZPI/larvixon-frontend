import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';

import 'package:larvixon_frontend/src/user/domain/entities/user.dart';

abstract class UserRepository {
  Stream<User> get userStream;
  TaskEither<Failure, User> fetchUserProfile();

  TaskEither<Failure, void> updateUserProfileDetails({
    String? phoneNumber,
    String? bio,
    String? org,
  });
  TaskEither<Failure, void> updateUserProfilePhoto({
    required Uint8List bytes,
    required String fileName,
  });
  void dispose();
}
