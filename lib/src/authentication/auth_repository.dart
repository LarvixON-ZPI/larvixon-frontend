import 'auth_datasource.dart';
import '../../core/token_storage.dart';

class AuthRepository {
  final AuthDataSource dataSource;
  final TokenStorage tokenStorage;

  AuthRepository({required this.dataSource, required this.tokenStorage});

  Future<void> login({required String email, required String password}) async {
    final data = await dataSource.login(email: email, password: password);
    final accessToken = data['access'];
    final refreshToken = data['refresh'];
    if (accessToken != null && refreshToken != null) {
      await tokenStorage.saveAccessToken(accessToken);
      await tokenStorage.saveRefreshToken(refreshToken);
    } else {
      throw Exception('Login failed: tokens missing');
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) async {
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
      throw Exception('Login failed: tokens missing');
    }
  }

  Future<void> refreshTokens() async {
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
      throw Exception('Token refresh failed');
    }
  }

  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    // TODO: Implement actual verification logic via api/verify
    if (await tokenStorage.hasTokens()) {
      return true;
    }
    return false;
  }
}
