import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/src/authentication/auth_repository.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthBloc', () {
    late AuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    test('initial state is AuthState with initial status', () {
      final authBloc = AuthBloc(mockAuthRepository);
      expect(authBloc.state, const AuthState(status: AuthStatus.initial));
    });

    group('AuthSignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when sign up succeeds',
        build: () {
          when(() => mockAuthRepository.register(
                email: any(named: 'email'),
                password: any(named: 'password'),
                passwordConfirm: any(named: 'passwordConfirm'),
                firstName: any(named: 'firstName'),
                lastName: any(named: 'lastName'),
                username: any(named: 'username'),
              )).thenAnswer((_) async {});
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(
          AuthSignUpRequested(
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            firstName: 'John',
            lastName: 'Doe',
            username: 'johndoe',
          ),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(status: AuthStatus.authenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.register(
                email: 'test@example.com',
                password: 'password123',
                passwordConfirm: 'password123',
                firstName: 'John',
                lastName: 'Doe',
                username: 'johndoe',
              )).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when sign up fails',
        build: () {
          when(() => mockAuthRepository.register(
                email: any(named: 'email'),
                password: any(named: 'password'),
                passwordConfirm: any(named: 'passwordConfirm'),
                firstName: any(named: 'firstName'),
                lastName: any(named: 'lastName'),
                username: any(named: 'username'),
              )).thenThrow(Exception('Registration failed'));
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(
          AuthSignUpRequested(
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            firstName: 'John',
            lastName: 'Doe',
            username: 'johndoe',
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

    group('AuthSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when sign in succeeds',
        build: () {
          when(() => mockAuthRepository.login(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async {});
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(status: AuthStatus.authenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.login(
                email: 'test@example.com',
                password: 'password123',
              )).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when sign in fails',
        build: () {
          when(() => mockAuthRepository.login(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenThrow(Exception('Login failed'));
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(
          AuthSignInRequested(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
        ),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            errorMessage: 'Exception: Login failed',
          ),
        ],
      );
    });

    group('AuthSignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [unauthenticated] when sign out succeeds',
        build: () {
          when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(AuthSignOutRequested()),
        expect: () => [
          const AuthState(status: AuthStatus.unauthenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.logout()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [error] when sign out fails',
        build: () {
          when(() => mockAuthRepository.logout())
              .thenThrow(Exception('Logout failed'));
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(AuthSignOutRequested()),
        expect: () => [
          const AuthState(
            status: AuthStatus.error,
            errorMessage: 'Exception: Logout failed',
          ),
        ],
      );
    });

    group('AuthVerificationRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when user is logged in',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => true);
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(AuthVerificationRequested()),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(status: AuthStatus.authenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isLoggedIn()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when user is not logged in',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => false);
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(AuthVerificationRequested()),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(status: AuthStatus.unauthenticated),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isLoggedIn()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when verification fails',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenThrow(Exception('Verification failed'));
          return AuthBloc(mockAuthRepository);
        },
        act: (bloc) => bloc.add(AuthVerificationRequested()),
        expect: () => [
          const AuthState(status: AuthStatus.loading),
          const AuthState(
            status: AuthStatus.error,
            errorMessage: 'Exception: Verification failed',
          ),
        ],
      );
    });

    group('AuthState', () {
      test('supports value equality', () {
        const state1 = AuthState(status: AuthStatus.initial);
        const state2 = AuthState(status: AuthStatus.initial);
        expect(state1, equals(state2));
      });

      test('copyWith returns new instance with updated values', () {
        const state = AuthState(status: AuthStatus.initial);
        final newState = state.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: 'Test error',
        );
        
        expect(newState.status, AuthStatus.authenticated);
        expect(newState.errorMessage, 'Test error');
        expect(state.status, AuthStatus.initial);
        expect(state.errorMessage, isNull);
      });

      test('copyWith preserves existing values when not specified', () {
        const state = AuthState(
          status: AuthStatus.error,
          errorMessage: 'Original error',
        );
        final newState = state.copyWith(status: AuthStatus.loading);
        
        expect(newState.status, AuthStatus.loading);
        expect(newState.errorMessage, 'Original error');
      });
    });

    group('AuthEvent', () {
      test('AuthSignInRequested supports value equality', () {
        final event1 = AuthSignInRequested(
          email: 'test@example.com',
          password: 'password',
        );
        final event2 = AuthSignInRequested(
          email: 'test@example.com',
          password: 'password',
        );
        expect(event1, equals(event2));
      });

      test('AuthSignUpRequested supports value equality', () {
        final event1 = AuthSignUpRequested(
          email: 'test@example.com',
          password: 'password',
          confirmPassword: 'password',
          firstName: 'John',
          lastName: 'Doe',
          username: 'johndoe',
        );
        final event2 = AuthSignUpRequested(
          email: 'test@example.com',
          password: 'password',
          confirmPassword: 'password',
          firstName: 'John',
          lastName: 'Doe',
          username: 'johndoe',
        );
        expect(event1, equals(event2));
      });

      test('AuthSignOutRequested supports value equality', () {
        final event1 = AuthSignOutRequested();
        final event2 = AuthSignOutRequested();
        expect(event1, equals(event2));
      });

      test('AuthVerificationRequested supports value equality', () {
        final event1 = AuthVerificationRequested();
        final event2 = AuthVerificationRequested();
        expect(event1, equals(event2));
      });
    });
  });
}