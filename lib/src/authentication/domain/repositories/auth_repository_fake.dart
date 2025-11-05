import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryFake implements AuthRepository {
  bool _isLoggedIn = false;

  @override
  TaskEither<Failure, void> login({
    required String email,
    required String password,
  }) {
    return TaskEither<Failure, void>.tryCatch(() async {
      await Future.delayed(const Duration(milliseconds: 150));
      _isLoggedIn = true;
      return;
    }, (error, _) => UnknownFailure(message: error.toString()));
  }

  @override
  TaskEither<Failure, void> logout() {
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(const Duration(milliseconds: 50));
        _isLoggedIn = false;
      },
      (error, stackTrace) {
        return UnknownFailure(message: "Unknown failure");
      },
    );
  }

  @override
  TaskEither<Failure, void> refreshTokens() {
    return TaskEither.tryCatch(
      () async {
        return await Future.delayed(
          const Duration(milliseconds: 100),
          () => true,
        );
      },
      (error, stackTrace) {
        return UnknownFailure(message: "Unknown failure");
      },
    );
  }

  @override
  TaskEither<Failure, void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) {
    return TaskEither<Failure, void>.tryCatch(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      _isLoggedIn = true;
    }, (error, _) => UnknownFailure(message: error.toString()));
  }

  @override
  TaskEither<Failure, bool> hasValidToken() {
    return TaskEither.right(_isLoggedIn);
  }

  @override
  TaskEither<Failure, bool> verifyToken() {
    return TaskEither.right(_isLoggedIn);
  }

  @override
  TaskEither<Failure, AuthStatus> checkAuthStatus() {
    return TaskEither.right(
      _isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }
}
