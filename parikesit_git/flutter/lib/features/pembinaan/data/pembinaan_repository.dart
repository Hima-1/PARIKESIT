import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/config/app_config.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';

import 'package:parikesit/core/network/providers/dio_provider.dart';
import '../../../core/utils/base_repository.dart';
import '../../../core/utils/file_saver.dart';
import '../../../core/utils/file_type.dart';
import '../../../core/utils/image_to_pdf.dart';
import '../../../core/utils/logger.dart';
import '../../admin/data/admin_user_repository.dart';
import '../../admin/domain/admin_activity_query.dart';
import '../domain/pembinaan.dart';

abstract class IPembinaanRepository {
  Future<List<Pembinaan>> getActivities({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<PaginatedResponse<Pembinaan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  });
  Future<Pembinaan> getActivityById(String id);
  Future<Pembinaan> createActivity(Map<String, dynamic> data);
  Future<Pembinaan> updateActivity(String id, Map<String, dynamic> data);
  Future<void> deleteActivity(String id);
  Future<DownloadTarget> downloadActivity(
    String id, {
    required DownloadTarget target,
    void Function(int received, int total)? onReceiveProgress,
  });
  Future<List<int>> downloadPublicFile(String storagePath);
}

class PembinaanRepositoryImpl extends BaseRepository
    implements IPembinaanRepository {
  PembinaanRepositoryImpl(this._client);

  final Dio _client;

  String? _extractDownloadFileName(Headers headers) {
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

  List<int> _extractDownloadBytes(
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

  String _toPublicStorageUrl(String storagePath) {
    final normalizedPath = storagePath.startsWith('storage/')
        ? storagePath.substring('storage/'.length)
        : storagePath;
    final base = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;
    return '$base/storage/$normalizedPath';
  }

  @override
  Future<DownloadTarget> downloadActivity(
    String id, {
    required DownloadTarget target,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    return safeRequest(() async {
      AppLogger.debug(
        '[downloadPembinaanZip] destination=${target.tempFilePath} baseUrl=${_client.options.baseUrl}',
      );

      final response = await _client.get<ResponseBody>(
        '/pembinaan/$id/download',
        options: Options(
          responseType: ResponseType.stream,
          headers: const <String, dynamic>{
            Headers.acceptHeader: 'application/zip, application/octet-stream',
          },
        ),
      );

      final responseBody = response.data;
      if (responseBody == null) {
        throw const FormatException('Response download kosong');
      }

      final sink = File(target.tempFilePath).openWrite();
      var received = 0;
      final total = responseBody.contentLength;

      try {
        await for (final chunk in responseBody.stream) {
          received += chunk.length;
          sink.add(chunk);
          onReceiveProgress?.call(received, total);
        }
      } finally {
        await sink.flush();
        await sink.close();
      }

      final backendFileName = _extractDownloadFileName(response.headers);
      final resolvedFileName = FileSaver.sanitizeDownloadFileName(
        backendFileName == null || backendFileName.trim().isEmpty
            ? target.fileName
            : backendFileName,
      );

      AppLogger.debug(
        '[downloadPembinaanZip] temp file saved to ${target.tempFilePath} finalFileName=$resolvedFileName',
      );
      return DownloadTarget(
        fileName: resolvedFileName,
        tempFilePath: target.tempFilePath,
      );
    }, label: 'downloadActivity');
  }

  @override
  Future<List<int>> downloadPublicFile(String storagePath) async {
    return safeRequest(() async {
      final response = await _client.get<List<int>>(
        _toPublicStorageUrl(storagePath),
        options: Options(responseType: ResponseType.bytes),
      );
      return _extractDownloadBytes(
        response,
        label: 'downloadPembinaanPublicFile',
      );
    }, label: 'downloadPublicFile');
  }

  @override
  Future<List<Pembinaan>> getActivities({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, dynamic> queryParameters = {};
    if (search != null) queryParameters['search'] = search;
    if (startDate != null) {
      queryParameters['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParameters['end_date'] = endDate.toIso8601String().split('T')[0];
    }

    final response = await _client.get<dynamic>(
      '/pembinaan',
      queryParameters: queryParameters,
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => Pembinaan.fromJson(e)).toList();
  }

  @override
  Future<PaginatedResponse<Pembinaan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _client.get<dynamic>(
      '/pembinaan',
      queryParameters: <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'sort': switch (sort ?? AdminActivitySortField.createdAt) {
          AdminActivitySortField.createdAt => 'created_at',
          AdminActivitySortField.title => 'judul_pembinaan',
        },
        'direction': (direction ?? SortDirection.desc).apiValue,
      },
    );
    return parseLaravelPaginatedResponse(
      response.data,
      Pembinaan.fromJson,
      label: 'getPembinaanActivitiesPage',
    );
  }

  @override
  Future<Pembinaan> getActivityById(String id) async {
    final response = await _client.get<dynamic>('/pembinaan/$id');
    return Pembinaan.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Pembinaan> createActivity(Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {...data};

    // Convert file paths to MultipartFile
    final fileFields = [
      'bukti_dukung_undangan',
      'daftar_hadir',
      'materi',
      'notula',
    ];

    for (final field in fileFields) {
      final path = formDataMap[field] as String?;
      if (path != null && path.isNotEmpty) {
        final kind = detectPickedFileKind(path);
        final finalPath = kind == PickedFileKind.image
            ? await generateSinglePagePdfFromImageFile(
                path,
                fileNamePrefix: field,
              )
            : path;
        formDataMap[field] = await MultipartFile.fromFile(
          finalPath,
          filename: '$field.pdf',
        );
      } else {
        formDataMap.remove(field);
      }
    }

    // Handle additional media files if present
    if (formDataMap.containsKey('files')) {
      final List<String> filePaths = List<String>.from(formDataMap['files']);
      formDataMap.remove('files');
      formDataMap['files[]'] = await Future.wait(
        filePaths.map((path) => MultipartFile.fromFile(path)),
      );
    }

    final response = await _client.post<dynamic>(
      '/pembinaan',
      data: FormData.fromMap(formDataMap),
      options: Options(contentType: 'multipart/form-data'),
    );
    return Pembinaan.fromJson(response.data['data']);
  }

  @override
  Future<Pembinaan> updateActivity(String id, Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {...data};

    // Convert file paths to MultipartFile
    final fileFields = [
      'bukti_dukung_undangan',
      'daftar_hadir',
      'materi',
      'notula',
    ];

    for (final field in fileFields) {
      final path = formDataMap[field] as String?;
      if (path != null && path.isNotEmpty) {
        final kind = detectPickedFileKind(path);
        final finalPath = kind == PickedFileKind.image
            ? await generateSinglePagePdfFromImageFile(
                path,
                fileNamePrefix: field,
              )
            : path;
        formDataMap[field] = await MultipartFile.fromFile(
          finalPath,
          filename: '$field.pdf',
        );
      } else {
        formDataMap.remove(field);
      }
    }

    // Handle additional media files if present
    if (formDataMap.containsKey('files')) {
      final List<String> filePaths = List<String>.from(formDataMap['files']);
      formDataMap.remove('files');
      formDataMap['files[]'] = await Future.wait(
        filePaths.map((path) => MultipartFile.fromFile(path)),
      );
    }

    // Use _method for Laravel spoofing if needed, but docs say PUT/PATCH
    // For dio, PATCH with FormData usually works if backend supports it
    final response = await _client.post<dynamic>(
      '/pembinaan/$id',
      data: FormData.fromMap({
        ...formDataMap,
        '_method': 'PATCH', // Laravel usually requires this for multipart PATCH
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
    return Pembinaan.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteActivity(String id) async {
    await _client.delete<dynamic>('/pembinaan/$id');
  }
}

final pembinaanRepositoryProvider = Provider<IPembinaanRepository>((ref) {
  final client = ref.watch(dioProvider);
  return PembinaanRepositoryImpl(client);
});
