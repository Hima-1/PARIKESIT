import 'package:dio/dio.dart';

class InvalidCredentialsException implements Exception {
  InvalidCredentialsException([this.message = 'Email atau password salah']);

  final String message;

  @override
  String toString() => message;
}

class LoginRequestException implements Exception {
  LoginRequestException([
    this.message = 'Terjadi gangguan jaringan. Coba lagi.',
  ]);

  final String message;

  @override
  String toString() => message;
}

Exception mapLoginException(Object error) {
  if (error is DioException && error.response?.statusCode == 422) {
    return InvalidCredentialsException();
  }

  return LoginRequestException();
}
