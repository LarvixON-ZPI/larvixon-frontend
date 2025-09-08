import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/domain/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

// Generate mock repository
@GenerateMocks([AuthRepository])
void main() {
  group('AuthBloc', () {
    late MockAuthRepository mockAuthRepository;
    late AuthBloc authBloc;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthState with status initial', () {
      expect(authBloc.state.status, AuthStatus.initial);
    });

    group('AuthSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when login is successful',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'test@example.com',
              password: 'password',
            ),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(status: AuthStatus.authenticated),
        ],
        verify: (bloc) {
          verify(
            mockAuthRepository.login(
              email: 'test@example.com',
              password: 'password',
            ),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'test@example.com',
              password: 'password',
            ),
          ).thenThrow(Exception('Login failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            errorMessage: 'Exception: Login failed',
          ),
        ],
      );
    });

    group('AuthSignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when registration is successful',
        build: () {
          when(
            mockAuthRepository.register(
              email: 'test@example.com',
              password: 'password',
              passwordConfirm: 'password',
              firstName: 'Test',
              lastName: 'User',
              username: 'testuser',
            ),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignUpRequested(
            email: 'test@example.com',
            password: 'password',
            confirmPassword: 'password',
            firstName: 'Test',
            lastName: 'User',
            username: 'testuser',
          ),
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(status: AuthStatus.authenticated),
        ],
      );
    });

    group('AuthSignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when logout is successful',
        build: () {
          when(mockAuthRepository.logout()).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignOutRequested()),
        expect: () => [AuthState(status: AuthStatus.unauthenticated)],
      );
    });
  });
}
