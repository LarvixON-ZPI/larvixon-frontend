part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String username;

  AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    confirmPassword,
    firstName,
    lastName,
    username,
  ];
}

class AuthVerificationRequested extends AuthEvent {}

class AuthRetryVerificationRequested extends AuthEvent {}
