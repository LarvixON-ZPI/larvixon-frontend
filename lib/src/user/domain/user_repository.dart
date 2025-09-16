import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';

import '../user.dart';

abstract class UserRepository {
  TaskEither<Failure, User> getUserProfile();

  TaskEither<Failure, User> updateUserProfile({required User user});
}
