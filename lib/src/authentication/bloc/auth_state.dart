part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated, error, loading }

final class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  // TODO: Add user field
  // final User? user;

  const AuthState({this.status = AuthStatus.initial, this.errorMessage});

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
