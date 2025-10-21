import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/user_repository.dart';
import '../domain/entities/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserState()) {
    on<UserProfileDataRequested>(_onUserProfileDataRequested);
    on<UserProfileDataUpdateRequested>(_onUserProfileDataUpdateRequested);
    on<UserProfileClearRequested>(_onUserProfileClearRequested);
  }

  FutureOr<void> _onUserProfileDataUpdateRequested(
    UserProfileDataUpdateRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true));
    var result = await userRepository
        .updateUserProfile(
          user: state.user!.copyWith(
            email: event.email,
            firstName: event.firstName,
            lastName: event.lastName,
            username: event.username,
            bio: event.bio,
            organization: event.organization,
            phoneNumber: event.phoneNumber,
          ),
        )
        .run();

    result.match(
      (error) => emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: error.toString(),
          isUpdating: false,
        ),
      ),
      (user) => emit(
        state.copyWith(
          user: user,
          status: UserStatus.success,
          isUpdating: false,
        ),
      ),
    );
  }

  FutureOr<void> _onUserProfileDataRequested(
    UserProfileDataRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));
    var result = await userRepository.getUserProfile().run();
    result.match(
      (error) => emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (user) => emit(state.copyWith(user: user, status: UserStatus.success)),
    );
  }

  FutureOr<void> _onUserProfileClearRequested(
    UserProfileClearRequested event,
    Emitter<UserState> emit,
  ) {
    emit(state.copyWith(user: null, status: UserStatus.initial));
  }
}
