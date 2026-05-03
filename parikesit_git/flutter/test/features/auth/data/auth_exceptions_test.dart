import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/auth/data/auth_exceptions.dart';

void main() {
  group('mapLoginException', () {
    test('maps 422 response to invalid credentials exception', () {
      final DioException error = DioException(
        requestOptions: RequestOptions(path: '/login'),
        response: Response<void>(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 422,
        ),
        type: DioExceptionType.badResponse,
      );

      final Exception mapped = mapLoginException(error);

      expect(mapped, isA<InvalidCredentialsException>());
      expect(mapped.toString(), contains('Email atau password salah'));
    });

    test('maps non-422 dio error to login request exception', () {
      final DioException error = DioException(
        requestOptions: RequestOptions(path: '/login'),
        response: Response<void>(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      final Exception mapped = mapLoginException(error);

      expect(mapped, isA<LoginRequestException>());
      expect(
        mapped.toString(),
        contains('Terjadi gangguan jaringan. Coba lagi.'),
      );
    });
  });
}
