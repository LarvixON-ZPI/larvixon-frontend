import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:larvixon_frontend/src/authentication/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthState()) {
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthVerificationRequested>(_onVerificationRequested);
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.register(
        email: event.email,
        password: event.password,
        passwordConfirm: event.confirmPassword,
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
      );
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.login(email: event.email, password: event.password);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logout();
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    print(
      'Transitioning from ${transition.currentState} to ${transition.nextState} via ${transition.event}',
    );
    super.onTransition(transition);
  }

  FutureOr<void> _onVerificationRequested(
    AuthVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      if (await _authRepository.isLoggedIn()) {
        emit(state.copyWith(status: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
