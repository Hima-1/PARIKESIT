import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';

import '../../../core/utils/file_saver.dart';
import '../../../core/utils/file_type.dart';
import '../../../core/utils/image_to_pdf.dart';
import '../../../core/utils/logger.dart';
import '../../admin/data/admin_user_repository.dart';
import '../../admin/domain/admin_activity_query.dart';
import '../domain/pembinaan.dart';
import 'download_helpers.dart';

class PembinaanRepository {
  PembinaanRepository(this._client);

  final Dio _client;

  Future<DownloadTarget> downloadActivity(
    String id, {
    required DownloadTarget target,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
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

    final backendFileName = extractDownloadFileName(response.headers);
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
  }

  Future<List<int>> downloadPublicFile(String storagePath) async {
    final response = await _client.get<List<int>>(
      toPublicStorageUrl(storagePath),
      options: Options(responseType: ResponseType.bytes),
    );
    return extractDownloadBytes(response, label: 'downloadPembinaanPublicFile');
  }

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

  Future<Pembinaan> getActivityById(String id) async {
    final response = await _client.get<dynamic>('/pembinaan/$id');
    return Pembinaan.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Pembinaan> createActivity(Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {...data};

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

    if (formDataMap.containsKey('files')) {
      final List<String> filePaths = List<String>.from(formDataMap['files']);
      formDataMap.remove('files');
      formDataMap['files[]'] = await Future.wait(
        filePaths.map(MultipartFile.fromFile),
      );
    }

    final response = await _client.post<dynamic>(
      '/pembinaan',
      data: FormData.fromMap(formDataMap),
      options: Options(contentType: 'multipart/form-data'),
    );
    return Pembinaan.fromJson(response.data['data']);
  }

  Future<Pembinaan> updateActivity(String id, Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {...data};

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

    if (formDataMap.containsKey('files')) {
      final List<String> filePaths = List<String>.from(formDataMap['files']);
      formDataMap.remove('files');
      formDataMap['files[]'] = await Future.wait(
        filePaths.map(MultipartFile.fromFile),
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

  Future<void> deleteActivity(String id) async {
    await _client.delete<dynamic>('/pembinaan/$id');
  }
}

final pembinaanRepositoryProvider = Provider<PembinaanRepository>((ref) {
  final client = ref.watch(dioProvider);
  return PembinaanRepository(client);
});
