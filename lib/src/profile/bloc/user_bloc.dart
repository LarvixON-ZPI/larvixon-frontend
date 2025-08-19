import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user.dart';
import '../user_repository.dart';

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
  ) async {}

  FutureOr<void> _onUserProfileDataRequested(
    UserProfileDataRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      User user = await userRepository.getUserProfile();
      emit(state.copyWith(user: user, status: UserStatus.success));
    } catch (error) {
      print(error);
      emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onUserProfileClearRequested(
    UserProfileClearRequested event,
    Emitter<UserState> emit,
  ) {
    emit(state.copyWith(user: null, status: UserStatus.initial));
  }

  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    super.onTransition(transition);
    print(
      'Transitioning from ${transition.currentState} to ${transition.nextState}',
    );
  }

  @override
  void onEvent(UserEvent event) {
    super.onEvent(event);
    print('Event received: $event');
  }
}
