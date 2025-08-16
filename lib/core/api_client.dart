import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/auth_interceptor.dart';
import 'package:larvixon_frontend/core/token_storage.dart';

final class ApiClient {
  final timeoutDuration = Duration(seconds: 30);
  final TokenStorage _tokenStorage;
  ApiClient(this._tokenStorage);

  BaseOptions get baseOptions => BaseOptions(
    connectTimeout: timeoutDuration,
    receiveTimeout: timeoutDuration,
    headers: {'Content-Type': 'application/json'},
  );

  late final Dio dio = _createDio();

  Dio _createDio() {
    final dioInstance = Dio(baseOptions);
    dioInstance.interceptors.add(AuthInterceptor(_tokenStorage, dioInstance));
    return dioInstance;
  }
}
