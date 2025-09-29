part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  error,
  loading,
  mfaRequired,
}

final class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final AuthError? error;
  // TODO: Add user field
  // final User? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AuthError? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, error];
}
