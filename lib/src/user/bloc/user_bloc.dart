import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';
import 'package:larvixon_frontend/src/user/domain/entities/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  StreamSubscription<User>? _userSubscription;
  UserBloc(this.userRepository) : super(const UserState()) {
    on<UserProfileDataRequested>(_onUserProfileDataRequested);
    on<UserProfileDataUpdateRequested>(_onUserProfileDataUpdateRequested);
    on<UserProfileClearRequested>(_onUserProfileClearRequested);
    on<_UserStreamUpdated>(_onUserStreamUpdated);
    _userSubscription = userRepository.userStream.listen((user) {
      add(_UserStreamUpdated(user));
    });
  }

  FutureOr<void> _onUserProfileDataUpdateRequested(
    UserProfileDataUpdateRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true));
    final result = await userRepository
        .updateUserProfileDetails(
          bio: event.bio,
          org: event.organization,
          phoneNumber: event.phoneNumber,
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
      (user) =>
          emit(state.copyWith(status: UserStatus.success, isUpdating: false)),
    );
  }

  FutureOr<void> _onUserProfileDataRequested(
    UserProfileDataRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));
    final result = await userRepository.fetchUserProfile().run();
    result.match(
      (error) => emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (user) => emit(state.copyWith(status: UserStatus.success)),
    );
  }

  FutureOr<void> _onUserProfileClearRequested(
    UserProfileClearRequested event,
    Emitter<UserState> emit,
  ) {
    emit(state.copyWith(status: UserStatus.initial));
  }

  void _onUserStreamUpdated(_UserStreamUpdated event, Emitter<UserState> emit) {
    emit(state.copyWith(status: UserStatus.success, user: event.user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
