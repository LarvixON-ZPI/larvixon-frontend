import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/authentication/data/auth_datasource.dart';
import 'package:larvixon_frontend/core/token_storage.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.dataSource, required this.tokenStorage});

  @override
  TaskEither<Failure, void> login({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final data = await dataSource.login(email: email, password: password);
        final accessToken = data['access'];
        final refreshToken = data['refresh'];
        if (accessToken != null && refreshToken != null) {
          await tokenStorage.saveAccessToken(accessToken);
          await tokenStorage.saveRefreshToken(refreshToken);
        } else {
          throw const MalformedResponseFailure(
            statusCode: 0,
            message: "Missing access or refresh token",
          );
        }
      },
      (e, stackTrace) {
        final apiFailure = e is DioException
            ? e.toApiFailure()
            : UnknownFailure(message: e.toString());
        if (apiFailure is ValidationFailure) {
          final authFailure = AuthFailure.fromValidationFailure(apiFailure);
          if (authFailure is! UnknownAuthFailure) return authFailure;
        }
        return apiFailure;
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
    return TaskEither.tryCatch(
      () async {
        final data = await dataSource.register(
          username: username,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm,
          firstName: firstName,
          lastName: lastName,
        );
        final accessToken = data['access'];
        final refreshToken = data['refresh'];
        if (accessToken != null && refreshToken != null) {
          await tokenStorage.saveAccessToken(accessToken);
          await tokenStorage.saveRefreshToken(refreshToken);
        } else {
          throw const MalformedResponseFailure(
            statusCode: 0,
            message: "Missing access or refresh token",
          );
        }
      },
      (e, stackTrace) {
        final apiFailure = e is DioException
            ? e.toApiFailure()
            : UnknownFailure(message: e.toString());
        if (apiFailure is ValidationFailure) {
          final authFailure = AuthFailure.fromValidationFailure(apiFailure);
          if (authFailure is! UnknownAuthFailure) return authFailure;
        }
        return apiFailure;
      },
    );
  }

  @override
  TaskEither<Failure, void> refreshTokens() {
    return TaskEither.tryCatch(
      () async {
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken == null) {
          throw Exception('No refresh token available');
        }

        final data = await dataSource.refreshToken(refreshToken: refreshToken);
        final newAccessToken = data['access'];
        final newRefreshToken = data['refresh'];

        if (newAccessToken != null && newRefreshToken != null) {
          await tokenStorage.saveAccessToken(newAccessToken);
          await tokenStorage.saveRefreshToken(newRefreshToken);
        } else {
          throw const MalformedResponseFailure(
            statusCode: 0,
            message: "Missing access or refresh token",
          );
        }
      },
      (e, stackTrace) {
        if (e is DioException) return e.toApiFailure();
        return UnknownFailure(message: e.toString());
      },
    );
  }

  @override
  TaskEither<Failure, void> logout() {
    return TaskEither.tryCatch(
      () async {
        await tokenStorage.clearTokens();
      },
      (e, stackTrace) {
        if (e is DioException) return e.toApiFailure();
        return UnknownFailure(message: e.toString());
      },
    );
  }

  @override
  TaskEither<Failure, bool> isLoggedIn() {
    return TaskEither.tryCatch(
      () async {
        if (await tokenStorage.hasTokens()) {
          return true;
        }
        return false;
      },
      (e, stackTrace) {
        if (e is DioException) return e.toApiFailure();
        return UnknownFailure(message: e.toString());
      },
    );
  }
}
