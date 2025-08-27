abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  });

  Future<void> refreshTokens();

  Future<void> logout();

  Future<bool> isLoggedIn();
}
