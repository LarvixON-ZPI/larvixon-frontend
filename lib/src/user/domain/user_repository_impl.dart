import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart'
    show Failure, UnknownFailure;

import '../data/user_datasource.dart';
import '../user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  TaskEither<Failure, User> getUserProfile() {
    return TaskEither.tryCatch(
      () async {
        final data = await dataSource.getUserProfile();
        return User.fromJson(data);
      },
      (error, stackTrace) {
        return UnknownFailure(message: error.toString());
      },
    );
  }

  @override
  TaskEither<Failure, User> updateUserProfile({required User user}) {
    return TaskEither.tryCatch(
      () async {
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
      },
      (error, stackTrace) {
        return UnknownFailure(message: error.toString());
      },
    );
  }
}
