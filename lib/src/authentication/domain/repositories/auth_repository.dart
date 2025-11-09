import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';

abstract class AuthRepository {
  TaskEither<Failure, void> login({
    required String email,
    required String password,
  });

  TaskEither<Failure, void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  });

  TaskEither<Failure, void> refreshTokens();

  TaskEither<Failure, void> logout();

  TaskEither<Failure, AuthStatus> checkAuthStatus();
  TaskEither<Failure, bool> hasValidToken();
  TaskEither<Failure, bool> verifyToken();
}
