import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/core/errors/storage_failures.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
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
        if (apiFailure is BadRequestFailure) {
          final authFailure = AuthFailure.fromBadRequest(apiFailure);
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
        if (apiFailure is BadRequestFailure) {
          final authFailure = AuthFailure.fromBadRequest(apiFailure);
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
        return TokenStorageFailure(
          message: "Failed to clear tokens: ${e.toString()}",
        );
      },
    );
  }

  @override
  TaskEither<Failure, AuthStatus> checkAuthStatus() {
    return TaskEither.tryCatch(
      () async {
        final token = await tokenStorage.getAccessToken();

        if (token == null || token.isEmpty) {
          return AuthStatus.unauthenticated;
        }
        if (JwtDecoder.isExpired(token)) {
          final refreshResult = await refreshTokens().run();
          return refreshResult.match(
            (failure) => AuthStatus.unauthenticated,
            (_) => AuthStatus.authenticated,
          );
        }

        return AuthStatus.authenticated;
      },
      (error, stackTrace) => TokenStorageFailure(
        message: 'Failed to check auth status: ${error.toString()}',
      ),
    );
  }

  @override
  TaskEither<Failure, bool> hasValidToken() {
    return TaskEither.tryCatch(
      () async {
        try {
          final token = await tokenStorage.getAccessToken();

          if (token == null || token.isEmpty) {
            return false;
          }

          if (JwtDecoder.isExpired(token)) {
            final refreshResult = await refreshTokens().run();
            return refreshResult.match((failure) {
              return false;
            }, (_) => true);
          }

          // Check if token expires soon (within 5 minutes)
          final expirationDate = JwtDecoder.getExpirationDate(token);
          final now = DateTime.now();
          const bufferTime = Duration(minutes: 5);

          if (expirationDate.isBefore(now.add(bufferTime))) {
            final refreshResult = await refreshTokens().run();
            return refreshResult.match((failure) {
              return !JwtDecoder.isExpired(token);
            }, (_) => true);
          }

          return true;
        } catch (e) {
          return false;
        }
      },
      (error, stackTrace) {
        return TokenStorageFailure(
          message: 'Failed to check token: ${error.toString()}',
        );
      },
    );
  }

  @override
  TaskEither<Failure, bool> verifyToken() {
    return TaskEither.tryCatch(
      () async {
        final localCheck = await hasValidToken().run();
        final hasLocal = localCheck.match(
          (failure) => false,
          (isValid) => isValid,
        );

        if (!hasLocal) {
          return false;
        }
        try {
          final token = await tokenStorage.getAccessToken();
          if (token == null) return false;
          await dataSource.verifyToken(token: token);
          return true;
        } on DioException catch (e) {
          if (e.response?.statusCode == 401) {
            await tokenStorage.clearTokens();
            return false;
          }
          return true;
        }
      },
      (error, stackTrace) {
        if (error is DioException) {
          return error.toApiFailure();
        }
        return UnknownFailure(message: error.toString());
      },
    );
  }
}
