import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_error.dart';
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
          const AuthState(status: AuthStatus.loading),
          const AuthState(status: AuthStatus.authenticated),
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
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            errorMessage: 'Exception: Login failed',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with invalid credentials',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'test@example.com',
              password: 'wrong-password',
            ),
          ).thenThrow(const InvalidCredentialsError());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(
            email: 'test@example.com',
            password: 'wrong-password',
          ),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: InvalidCredentialsError(),
            errorMessage: 'Invalid email or password',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with disabled account',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'disabled@example.com',
              password: 'password',
            ),
          ).thenThrow(const DisabledAccountError());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(
            email: 'disabled@example.com',
            password: 'password',
          ),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: DisabledAccountError(),
            errorMessage: 'Account is disabled',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, mfaRequired] when MFA is required',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'mfa@example.com',
              password: 'password',
            ),
          ).thenThrow(const MfaRequiredButNoCodeError());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'mfa@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.mfaRequired,
            error: MfaRequiredButNoCodeError(),
            errorMessage: 'Multi-factor authentication is required',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with field validation errors',
        build: () {
          when(mockAuthRepository.login(email: '', password: '')).thenThrow(
            const FieldValidationError({
              'email': ['This field is required.'],
              'password': ['This field is required.'],
            }),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignInRequested(email: '', password: '')),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: FieldValidationError({
              'email': ['This field is required.'],
              'password': ['This field is required.'],
            }),
            errorMessage: 'Validation errors occurred',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with network error',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'test@example.com',
              password: 'password',
            ),
          ).thenThrow(const NetworkError('Network connection failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: NetworkError('Network connection failed'),
            errorMessage: 'Network connection failed',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with server error',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'test@example.com',
              password: 'password',
            ),
          ).thenThrow(const ServerError('Internal server error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: ServerError('Internal server error'),
            errorMessage: 'Internal server error',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with invalid MFA code',
        build: () {
          when(
            mockAuthRepository.login(
              email: 'mfa@example.com',
              password: 'password',
            ),
          ).thenThrow(const InvalidMfaCodeError());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'mfa@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: InvalidMfaCodeError(),
            errorMessage: 'Invalid MFA code',
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
          const AuthState(status: AuthStatus.loading),
          const AuthState(status: AuthStatus.authenticated),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when registration fails with field validation errors',
        build: () {
          when(
            mockAuthRepository.register(
              email: 'invalid-email',
              password: 'password',
              passwordConfirm: 'password',
              firstName: 'Test',
              lastName: 'User',
              username: 'existing-user',
            ),
          ).thenThrow(
            const FieldValidationError({
              'username': ['This username is already taken.'],
              'email': ['Enter a valid email address.'],
            }),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignUpRequested(
            email: 'invalid-email',
            password: 'password',
            confirmPassword: 'password',
            firstName: 'Test',
            lastName: 'User',
            username: 'existing-user',
          ),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: FieldValidationError({
              'username': ['This username is already taken.'],
              'email': ['Enter a valid email address.'],
            }),
            errorMessage: 'Validation errors occurred',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when registration fails with generic error',
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
          ).thenThrow(Exception('Registration failed'));
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
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            errorMessage: 'Exception: Registration failed',
          ),
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
        expect: () => [const AuthState(status: AuthStatus.unauthenticated)],
      );
    });
  });
}
