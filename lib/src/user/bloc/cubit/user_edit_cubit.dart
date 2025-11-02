import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';

part 'user_edit_state.dart';

class UserEditCubit extends Cubit<UserEditState> {
  final UserRepository _repository;
  UserEditCubit({required UserRepository repository})
    : _repository = repository,
      super(const UserEditState());

  Future<void> updateDetails({
    String? phoneNumber,
    String? bio,
    String? organization,
  }) async {
    emit(state.copyWith(status: EditStatus.saving));
    final result = await _repository
        .updateUserProfileDetails(
          phoneNumber: phoneNumber,
          bio: bio,
          org: organization,
        )
        .run();

    result.match(
      (failure) {
        emit(state.copyWith(status: EditStatus.error));
      },
      (success) {
        emit(state.copyWith(status: EditStatus.success));
      },
    );
  }

  Future<void> updatePhoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    emit(state.copyWith(status: EditStatus.uploadingPhoto));
    final result = await _repository
        .updateUserProfilePhoto(bytes: bytes, fileName: fileName)
        .run();
    result.match(
      (failure) {
        print("Error: ${failure.message}");
        emit(
          state.copyWith(
            status: EditStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(status: EditStatus.success));
      },
    );
  }
}
