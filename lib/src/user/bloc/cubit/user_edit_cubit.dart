import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/common/services/file_picker/file_pick_result.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';

part 'user_edit_state.dart';

class UserEditCubit extends Cubit<UserEditState> {
  final UserRepository _repository;
  UserEditCubit({required UserRepository repository})
    : _repository = repository,
      super(const UserEditState(fieldErrors: {}));

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
        final fieldErrors = failure is ValidationFailure
            ? Map<String, String>.unmodifiable(failure.fieldErrors)
            : const <String, String>{};

        emit(
          state.copyWith(
            status: EditStatus.error,
            error: failure,
            fieldErrors: fieldErrors,
          ),
        );
      },

      (success) {
        emit(state.copyWith(status: EditStatus.success));
      },
    );
  }

  Future<void> updateBasicInfo({
    required String firstName,
    required String lastName,
  }) async {
    emit(state.copyWith(status: EditStatus.saving));
    final result = await _repository
        .updateUserProfileBasicInfo(firstName: firstName, lastName: lastName)
        .run();

    result.match(
      (failure) {
        final fieldErrors = failure is ValidationFailure
            ? Map<String, String>.unmodifiable(failure.fieldErrors)
            : const <String, String>{};
        emit(
          state.copyWith(
            status: EditStatus.error,
            error: failure,
            fieldErrors: fieldErrors,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: EditStatus.success,
            fieldErrors: const <String, String>{},
          ),
        );
      },
    );
  }

  Future<void> updatePhoto({required FilePickResult fileResult}) async {
    emit(state.copyWith(status: EditStatus.uploadingPhoto));

    // Convert stream to bytes
    final List<int> allBytes = [];
    await for (final chunk in fileResult.stream) {
      allBytes.addAll(chunk);
    }
    final bytes = Uint8List.fromList(allBytes);

    final result = await _repository
        .updateUserProfilePhoto(bytes: bytes, fileName: fileResult.name)
        .run();
    result.match(
      (failure) {
        emit(
          state.copyWith(
            status: EditStatus.error,
            errorMessage: failure.message,
            error: failure,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: EditStatus.success,
            fieldErrors: const <String, String>{},
          ),
        );
      },
    );
  }
}
