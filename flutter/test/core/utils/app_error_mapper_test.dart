import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/laravel_exceptions.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';

void main() {
  group('AppErrorMapper', () {
    test('maps connection error to offline message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
        error: const SocketException('Failed host lookup'),
      );

      expect(
        AppErrorMapper.toMessage(error),
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      );
    });

    test('maps validation exception to first field message', () {
      final error = LaravelValidationException(
        message: 'Data tidak valid',
        errors: <String, List<String>>{
          'email': <String>['Email wajib diisi'],
        },
      );

      expect(AppErrorMapper.toMessage(error), 'Email wajib diisi');
    });

    test('maps dio 500 to server message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      expect(
        AppErrorMapper.toMessage(error),
        'Server sedang mengalami gangguan. Silakan coba lagi nanti.',
      );
    });
  });
}
