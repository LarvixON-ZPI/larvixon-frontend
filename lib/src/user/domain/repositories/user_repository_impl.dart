import 'dart:async';
import 'dart:typed_data';

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
  final StreamController<User> _userController = StreamController.broadcast();

  UserRepositoryImpl({required this.dataSource});

  @override
  TaskEither<Failure, User> fetchUserProfile() {
    return TaskEither.tryCatch(
      () async {
        final data = await dataSource.getUserProfile();
        final user = mapper.dtoToEntity(data);
        _userController.add(user);
        return user;
      },
      (error, stackTrace) {
        return UnknownFailure(message: error.toString());
      },
    );
  }

  @override
  TaskEither<Failure, void> updateUserProfileDetails({
    String? phoneNumber,
    String? bio,
    String? org,
  }) {
    return TaskEither.tryCatch(
      () async {
        final dto = UserProfileDTO(
          profile: UserProfileDetailsDTO(
            bio: bio,
            organization: org,
            phone_number: phoneNumber,
          ),
        );
        await dataSource.updateUserProfileDetails(profileDetails: dto.profile!);
        fetchUserProfile().run();
      },
      (error, stackTrace) {
        return UnknownFailure(message: error.toString());
      },
    );
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
    return TaskEither.tryCatch(
      () async {
        await dataSource.updateUserProfilePhoto(
          bytes: bytes,
          fileName: fileName,
        );
        fetchUserProfile().run();
      },
      (error, stackTrace) {
        return UnknownFailure(message: error.toString());
      },
    );
  }
}
