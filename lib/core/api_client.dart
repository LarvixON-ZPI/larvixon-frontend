import 'package:dio/dio.dart';

import 'package:larvixon_frontend/core/auth_interceptor.dart';
import 'package:larvixon_frontend/core/token_storage.dart';

class ApiClient {
  Duration timeoutDuration = const Duration(seconds: 30);
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

class ApiClientFake implements ApiClient {
  @override
  Duration timeoutDuration = const Duration(seconds: 30);

  @override
  Dio _createDio() {
    throw UnimplementedError();
  }

  @override
  TokenStorage get _tokenStorage => throw UnimplementedError();

  @override
  BaseOptions get baseOptions => throw UnimplementedError();

  @override
  Dio get dio => throw UnsupportedError(
    'API Client not available in DEV mode. '
    'Switch to main.dart to connect to real backend, '
    'or mock this service in your repository.',
  );
}
