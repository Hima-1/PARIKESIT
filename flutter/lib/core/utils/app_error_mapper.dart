import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../network/laravel_exceptions.dart';

class AppErrorMapper {
  const AppErrorMapper._();

  static String toMessage(
    Object error, {
    String fallbackMessage = 'Terjadi kesalahan. Silakan coba lagi.',
  }) {
    if (error is LaravelValidationException) {
      final String firstValidationMessage = error.errors.values
          .expand((messages) => messages)
          .map((message) => message.trim())
          .firstWhere((message) => message.isNotEmpty, orElse: () => '');

      if (firstValidationMessage.isNotEmpty) {
        return firstValidationMessage;
      }

      if (error.message.trim().isNotEmpty) {
        return error.message.trim();
      }
    }

    if (error is UnauthorizedException) {
      return 'Sesi Anda telah berakhir. Silakan masuk kembali.';
    }

    if (error is ForbiddenException) {
      return 'Anda tidak memiliki akses untuk melakukan aksi ini.';
    }

    if (error is NotFoundException) {
      return 'Data yang diminta tidak ditemukan.';
    }

    if (error is InternalServerErrorException) {
      return 'Server sedang mengalami gangguan. Silakan coba lagi nanti.';
    }

    if (error is DioException) {
      return _mapDioException(error, fallbackMessage: fallbackMessage);
    }

    if (error is SocketException) {
      return 'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.';
    }

    if (error is TimeoutException) {
      return 'Permintaan melebihi batas waktu. Silakan coba lagi.';
    }

    return fallbackMessage;
  }

  static String _mapDioException(
    DioException error, {
    required String fallbackMessage,
  }) {
    if (error.type == DioExceptionType.connectionError ||
        error.error is SocketException) {
      return 'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Permintaan melebihi batas waktu. Silakan coba lagi.';
    }

    final int? statusCode = error.response?.statusCode;
    final dynamic responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final dynamic errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        for (final dynamic value in errors.values) {
          if (value is List) {
            for (final dynamic message in value) {
              if (message is String && message.trim().isNotEmpty) {
                return message.trim();
              }
            }
          }
        }
      }

      final dynamic responseMessage = responseData['message'];
      if (responseMessage is String && responseMessage.trim().isNotEmpty) {
        switch (statusCode) {
          case 401:
            return 'Sesi Anda telah berakhir. Silakan masuk kembali.';
          case 403:
            return 'Anda tidak memiliki akses untuk melakukan aksi ini.';
          case 404:
            return 'Data yang diminta tidak ditemukan.';
        }

        if (statusCode == 422) {
          return responseMessage.trim();
        }
      }
    }

    switch (statusCode) {
      case 401:
        return 'Sesi Anda telah berakhir. Silakan masuk kembali.';
      case 403:
        return 'Anda tidak memiliki akses untuk melakukan aksi ini.';
      case 404:
        return 'Data yang diminta tidak ditemukan.';
      case 422:
        return 'Data yang dikirim tidak valid. Periksa kembali isian Anda.';
      case 500:
      case 502:
      case 503:
        return 'Server sedang mengalami gangguan. Silakan coba lagi nanti.';
    }

    return fallbackMessage;
  }
}
