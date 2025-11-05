import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:meta/meta.dart';

import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthVerificationRequested>(_onVerificationRequested);
    on<AuthRetryVerificationRequested>(_onRetryVerificationRequested);
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository
        .register(
          email: event.email,
          password: event.password,
          passwordConfirm: event.confirmPassword,
          firstName: event.firstName,
          lastName: event.lastName,
          username: event.username,
        )
        .run();
    result.match(
      (failure) {
        print(failure);
        emit(
          state.copyWith(
            status: AuthStatus.error,
            error: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.authenticated));
      },
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository
        .login(email: event.email, password: event.password)
        .run();

    result.match((failure) {
      emit(
        state.copyWith(
          status: failure is MfaRequiredButNoCodeFailure
              ? AuthStatus.mfaRequired
              : AuthStatus.error,
          error: failure,
          errorMessage: failure.message,
        ),
      );
    }, (success) => emit(state.copyWith(status: AuthStatus.authenticated)));
    return;
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.logout().run();
    result.match(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
    );
  }

  Future<void> _onVerificationRequested(
    AuthVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.checkAuthStatus().run();
    result.match(
      (failure) => emit(
        state.copyWith(status: AuthStatus.unauthenticated, error: failure),
      ),
      (authStatus) {
        if (authStatus == AuthStatus.authenticated) {
          emit(state.copyWith(status: AuthStatus.authenticated));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> _onRetryVerificationRequested(
    AuthRetryVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _onVerificationRequested(AuthVerificationRequested(), emit);
  }
}
