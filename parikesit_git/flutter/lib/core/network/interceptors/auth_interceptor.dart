import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required this.onUnauthorized,
  }) : _tokenStorage = tokenStorage;
  final TokenStorage _tokenStorage;
  final VoidCallback onUnauthorized;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add Authorization header if a token exists
    final token = await _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Ensure we ask for JSON from Laravel
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized globally
    if (err.response?.statusCode == 401) {
      // Clear token and trigger logout logic
      await _tokenStorage.deleteToken();
      onUnauthorized();
    }

    return handler.next(err);
  }
}
