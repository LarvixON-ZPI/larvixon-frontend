import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart'
    show Failure, UnknownFailure;
import 'package:larvixon_frontend/src/user/data/mappers/user_mapper.dart';
import 'package:larvixon_frontend/src/user/data/models/user_dto.dart';

import 'package:larvixon_frontend/src/user/data/user_datasource.dart';
import 'package:larvixon_frontend/src/user/domain/entities/user.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;
  final UserMapper mapper = UserMapper();

  UserRepositoryImpl({required this.dataSource});

  @override
  TaskEither<Failure, User> getUserProfile() {
    return TaskEither.tryCatch(
      () async {
        final data = await dataSource.getUserProfile();
        return mapper.dtoToEntity(data);
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
          dto: mapper.entityToDto(user),
        );
        final dataDetails = await dataSource.updateUserProfileDetails(
          profileDetails: mapper.entityToDto(user).profile!,
        );
        final updatedDto = UserProfileDTO(
          email: data.email,
          username: data.username,
          first_name: data.first_name,
          last_name: data.last_name,
          date_joined: data.date_joined,
          profile: dataDetails,
        );

        return mapper.dtoToEntity(updatedDto);
      },
      (error, stackTrace) {
        return UnknownFailure(message: error.toString());
      },
    );
  }
}
