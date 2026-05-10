import 'package:dio/dio.dart';
import 'package:parikesit/core/config/app_config.dart';
import 'package:parikesit/core/utils/logger.dart';

String? extractDownloadFileName(Headers headers) {
  final contentDisposition = headers.value('content-disposition');

  if (contentDisposition == null || contentDisposition.isEmpty) {
    return null;
  }

  final utf8Match = RegExp(
    r"filename\*=UTF-8''([^;]+)",
    caseSensitive: false,
  ).firstMatch(contentDisposition);
  if (utf8Match != null) {
    return Uri.decodeFull(utf8Match.group(1)!);
  }

  final plainMatch = RegExp(
    r'filename="?([^";]+)"?',
    caseSensitive: false,
  ).firstMatch(contentDisposition);
  if (plainMatch != null) {
    return plainMatch.group(1);
  }

  return null;
}

List<int> extractDownloadBytes(
  Response<List<int>> response, {
  required String label,
}) {
  final statusCode = response.statusCode ?? 0;
  final contentTypeHeader =
      response.headers.value(Headers.contentTypeHeader) ?? '';
  final contentType = contentTypeHeader.toLowerCase();
  final bytes = response.data ?? const <int>[];

  AppLogger.debug(
    '[$label] status=$statusCode contentType=$contentTypeHeader bytes=${bytes.length}',
  );

  if (statusCode < 200 || statusCode >= 300) {
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Download gagal dengan status HTTP $statusCode',
    );
  }

  if (contentType.contains('application/json') ||
      contentType.contains('text/json')) {
    throw const FormatException(
      'Server mengembalikan JSON saat file diharapkan',
    );
  }

  if (bytes.isEmpty) {
    throw const FormatException('Response download kosong');
  }

  return bytes;
}

String toPublicStorageUrl(String storagePath) {
  final normalizedPath = storagePath.startsWith('storage/')
      ? storagePath.substring('storage/'.length)
      : storagePath;
  final base = AppConfig.baseUrl.endsWith('/')
      ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
      : AppConfig.baseUrl;
  return '$base/storage/$normalizedPath';
}
