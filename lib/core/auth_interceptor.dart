import 'package:dio/dio.dart';
import 'package:larvixon_frontend/core/constants/endpoints_auth.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio dio;
  bool _isRefreshing = false;
  final _requestsNeedRetry =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  AuthInterceptor(this._tokenStorage, this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    if (response != null &&
        response.statusCode == 401 &&
        response.requestOptions.path != AuthEndpoints.refreshToken) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        _requestsNeedRetry.add((
          options: response.requestOptions,
          handler: handler,
        ));
        final isRefreshSuccess = await _refreshToken();
        if (isRefreshSuccess) {
          for (var requestNeedRetry in _requestsNeedRetry) {
            dio
                .fetch(requestNeedRetry.options)
                .then((response) {
                  requestNeedRetry.handler.resolve(response);
                })
                .catchError((_) {});
          }
          _requestsNeedRetry.clear();
          _isRefreshing = false;
        } else {
          _requestsNeedRetry.clear();
        }
      } else {
        _requestsNeedRetry.add((
          options: response.requestOptions,
          handler: handler,
        ));
      }
    } else {
      return handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _tokenStorage.getRefreshToken();
      final res = await dio.post(
        AuthEndpoints.refreshToken,
        data: {'refresh': refreshToken},
      );
      if (res.statusCode != null && res.statusCode == 200) {
        final newAccessToken = res.data['data']['access'];
        await _tokenStorage.saveAccessToken(newAccessToken);
        final newRefreshToken = res.data['data']['refresh'];
        await _tokenStorage.saveRefreshToken(newRefreshToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
