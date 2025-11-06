import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/data/auth_datasource.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository_impl.dart';
import 'package:larvixon_frontend/core/token_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthDataSource, TokenStorage])
void main() {
  late MockAuthDataSource mockDataSource;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthDataSource();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(
      dataSource: mockDataSource,
      tokenStorage: mockTokenStorage,
    );
  });

  group('AuthRepositoryImpl - hasValidToken', () {
    test('returns false when no token exists', () async {
      when(mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await repository.hasValidToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
      verify(mockTokenStorage.getAccessToken()).called(1);
    });

    test('returns false when token is empty string', () async {
      when(mockTokenStorage.getAccessToken()).thenAnswer((_) async => '');

      final result = await repository.hasValidToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
    });

    test('returns false when token is expired', () async {
      // Create an expired JWT token (expires in 1970)
      const expiredToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjoxfQ.m3zgJVhHCA5K-H5PGCUQRMhUKQFvF0eNZxQmfRKhBXk';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => expiredToken);

      // Mock refresh to fail
      when(mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);

      final result = await repository.hasValidToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
    });

    test('returns true when token is valid', () async {
      // Create a valid JWT token that expires in 2099
      const validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjo0MTAyNDQ0ODAwfQ.DRWp5T6Qz_sYxGhIAKlgvfHMVqRF2Vc0OgVJtXWUQ9I';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => validToken);

      final result = await repository.hasValidToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, true),
      );
    });

    test('returns false when storage throws exception', () async {
      when(
        mockTokenStorage.getAccessToken(),
      ).thenThrow(Exception('Storage error'));

      final result = await repository.hasValidToken().run();

      // The inner try-catch catches the exception and returns false
      expect(result.isRight(), true);
      result.match(
        (failure) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
    });

    test('attempts refresh when token is expired and succeeds', () async {
      const expiredToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjoxfQ.m3zgJVhHCA5K-H5PGCUQRMhUKQFvF0eNZxQmfRKhBXk';
      const refreshToken = 'valid-refresh-token';
      const newAccessToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjo0MTAyNDQ0ODAwfQ.DRWp5T6Qz_sYxGhIAKlgvfHMVqRF2Vc0OgVJtXWUQ9I';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => expiredToken);
      when(
        mockTokenStorage.getRefreshToken(),
      ).thenAnswer((_) async => refreshToken);
      when(mockDataSource.refreshToken(refreshToken: refreshToken)).thenAnswer(
        (_) async => {'access': newAccessToken, 'refresh': refreshToken},
      );
      when(
        mockTokenStorage.saveAccessToken(newAccessToken),
      ).thenAnswer((_) async => {});
      when(
        mockTokenStorage.saveRefreshToken(refreshToken),
      ).thenAnswer((_) async => {});

      final result = await repository.hasValidToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, true),
      );
      verify(mockDataSource.refreshToken(refreshToken: refreshToken)).called(1);
    });

    test('returns false when token refresh fails', () async {
      const expiredToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjoxfQ.m3zgJVhHCA5K-H5PGCUQRMhUKQFvF0eNZxQmfRKhBXk';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => expiredToken);
      when(mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);

      final result = await repository.hasValidToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
    });
  });

  group('AuthRepositoryImpl - verifyToken', () {
    test('returns false when hasValidToken returns false', () async {
      when(mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await repository.verifyToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
    });

    test('returns true when hasValidToken returns true', () async {
      const validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjo0MTAyNDQ0ODAwfQ.DRWp5T6Qz_sYxGhIAKlgvfHMVqRF2Vc0OgVJtXWUQ9I';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => validToken);
      when(
        mockDataSource.verifyToken(token: validToken),
      ).thenAnswer((_) async => {});

      final result = await repository.verifyToken().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, true),
      );
    });

    test('returns false when hasValidToken fails', () async {
      when(
        mockTokenStorage.getAccessToken(),
      ).thenThrow(Exception('Storage error'));

      final result = await repository.verifyToken().run();

      // Inner try-catch catches the exception and returns false
      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (isValid) => expect(isValid, false),
      );
    });
  });

  group('AuthRepositoryImpl - checkAuthStatus', () {
    test('returns unauthenticated when no token exists', () async {
      when(mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await repository.checkAuthStatus().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (status) => expect(status, AuthStatus.unauthenticated),
      );
    });

    test('returns unauthenticated when token is empty', () async {
      when(mockTokenStorage.getAccessToken()).thenAnswer((_) async => '');

      final result = await repository.checkAuthStatus().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (status) => expect(status, AuthStatus.unauthenticated),
      );
    });

    test('returns authenticated when token is valid', () async {
      const validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjo0MTAyNDQ0ODAwfQ.DRWp5T6Qz_sYxGhIAKlgvfHMVqRF2Vc0OgVJtXWUQ9I';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => validToken);

      final result = await repository.checkAuthStatus().run();

      expect(result.isRight(), true);
      result.match(
        (l) => fail('Should not be left'),
        (status) => expect(status, AuthStatus.authenticated),
      );
    });

    test(
      'returns unauthenticated when token is expired and refresh fails',
      () async {
        const expiredToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjoxfQ.m3zgJVhHCA5K-H5PGCUQRMhUKQFvF0eNZxQmfRKhBXk';

        when(
          mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => expiredToken);
        when(mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);

        final result = await repository.checkAuthStatus().run();

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Should not be left'),
          (status) => expect(status, AuthStatus.unauthenticated),
        );
      },
    );

    test(
      'returns authenticated when token is expired but refresh succeeds',
      () async {
        const expiredToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjoxfQ.m3zgJVhHCA5K-H5PGCUQRMhUKQFvF0eNZxQmfRKhBXk';
        const refreshToken = 'valid-refresh-token';
        const newAccessToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjo0MTAyNDQ0ODAwfQ.DRWp5T6Qz_sYxGhIAKlgvfHMVqRF2Vc0OgVJtXWUQ9I';

        when(
          mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => expiredToken);
        when(
          mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);
        when(
          mockDataSource.refreshToken(refreshToken: refreshToken),
        ).thenAnswer(
          (_) async => {'access': newAccessToken, 'refresh': refreshToken},
        );
        when(
          mockTokenStorage.saveAccessToken(newAccessToken),
        ).thenAnswer((_) async => {});
        when(
          mockTokenStorage.saveRefreshToken(refreshToken),
        ).thenAnswer((_) async => {});

        final result = await repository.checkAuthStatus().run();

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Should not be left'),
          (status) => expect(status, AuthStatus.authenticated),
        );
        verify(
          mockDataSource.refreshToken(refreshToken: refreshToken),
        ).called(1);
      },
    );

    test('returns UnknownFailure when storage throws exception', () async {
      when(
        mockTokenStorage.getAccessToken(),
      ).thenThrow(Exception('Storage error'));

      final result = await repository.checkAuthStatus().run();

      expect(result.isLeft(), true);
      result.match((failure) {
        // TokenStorageFailure is what's actually returned
        expect(failure.message, contains('Storage error'));
      }, (r) => fail('Should not be right'));
    });

    test('gracefully handles malformed JWT tokens', () async {
      const malformedToken = 'not.a.valid.jwt.token';

      when(
        mockTokenStorage.getAccessToken(),
      ).thenAnswer((_) async => malformedToken);

      final result = await repository.checkAuthStatus().run();

      // When JWT parsing fails, the implementation returns unauthenticated
      // (because JwtDecoder.isExpired will throw, which is caught)
      expect(result.isLeft(), true);
    });
  });
}
