import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_failures.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

// Generate mock repository
@GenerateMocks([AuthRepository])
void main() {
  setUpAll(() {
    // Provide a dummy TaskEither for Mockito
    provideDummy<TaskEither<Failure, void>>(
      TaskEither<Failure, void>.right(unit),
    );
    provideDummy<TaskEither<Failure, bool>>(
      TaskEither<Failure, bool>.right(true),
    );
  });

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
          ).thenReturn(TaskEither<Failure, void>.right(unit));
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
          ).thenReturn(
            TaskEither<Failure, void>.left(
              UnknownFailure(message: 'Login failed'),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', 'Login failed')
              .having((s) => s.error, 'error', isA<UnknownFailure>()),
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
          ).thenReturn(
            TaskEither<Failure, void>.left(const InvalidCredentialsFailure()),
          );
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
            error: InvalidCredentialsFailure(),
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
          ).thenReturn(
            TaskEither<Failure, void>.left(const DisabledAccountFailure()),
          );
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
            error: DisabledAccountFailure(),
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
          ).thenReturn(
            TaskEither<Failure, void>.left(const MfaRequiredButNoCodeFailure()),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'mfa@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.mfaRequired,
            error: MfaRequiredButNoCodeFailure(),
            errorMessage: 'Multi-factor authentication is required',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails with field validation errors',
        build: () {
          when(mockAuthRepository.login(email: '', password: '')).thenReturn(
            TaskEither<Failure, void>.left(
              const ValidationFailure(
                fieldErrors: {
                  'email': 'This field is required.',
                  'password': 'This field is required.',
                },
                message: 'validation_failed',
              ),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignInRequested(email: '', password: '')),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: ValidationFailure(
              fieldErrors: {
                'email': 'This field is required.',
                'password': 'This field is required.',
              },
              message: 'validation_failed',
            ),
            errorMessage: 'validation_failed',
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
          ).thenReturn(
            TaskEither<Failure, void>.left(
              const RequestTimeoutFailure(message: 'timeout'),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: RequestTimeoutFailure(message: 'timeout'),
            errorMessage: 'timeout',
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
          ).thenReturn(
            TaskEither<Failure, void>.left(
              const InternalServerErrorFailure(
                message: 'internal_server_error',
              ),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'test@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: InternalServerErrorFailure(message: 'internal_server_error'),
            errorMessage: 'internal_server_error',
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
          ).thenReturn(
            TaskEither<Failure, void>.left(const InvalidMfaCodeFailure()),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(email: 'mfa@example.com', password: 'password'),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            error: InvalidMfaCodeFailure(),
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
          ).thenReturn(TaskEither<Failure, void>.right(unit));
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
          ).thenReturn(
            TaskEither<Failure, void>.left(
              const ValidationFailure(
                fieldErrors: {
                  'username': 'This username is already taken.',
                  'email': 'Enter a valid email address.',
                },
                message: 'validation_failed',
              ),
            ),
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
            error: ValidationFailure(
              fieldErrors: {
                'username': 'This username is already taken.',
                'email': 'Enter a valid email address.',
              },
              message: 'validation_failed',
            ),
            errorMessage: 'validation_failed',
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
          ).thenReturn(
            TaskEither<Failure, void>.left(
              UnknownFailure(message: 'Registration failed'),
            ),
          );
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
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Registration failed',
              )
              .having((s) => s.error, 'error', isA<UnknownFailure>()),
        ],
      );
    });

    group('AuthSignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when logout is successful',
        build: () {
          when(
            mockAuthRepository.logout(),
          ).thenReturn(TaskEither<Failure, void>.right(unit));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignOutRequested()),
        expect: () => [const AuthState(status: AuthStatus.unauthenticated)],
      );
    });
  });
}
