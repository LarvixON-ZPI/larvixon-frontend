import 'auth_repository.dart';

class AuthRepositoryFake implements AuthRepository {
  @override
  Future<bool> isLoggedIn() async {
    return await Future.delayed(const Duration(milliseconds: 100), () => true);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> refreshTokens() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
