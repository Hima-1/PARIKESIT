import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/laravel_response.dart';
import '../../../core/network/paginated_response.dart';
import '../../../core/network/providers/dio_provider.dart';
import '../domain/dashboard_stats.dart';
import '../domain/opd_dashboard_progress.dart';
import '../domain/opd_performance.dart';
import '../domain/walidata_dashboard_progress.dart';

class DashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;

  Future<DashboardStats> getDashboardStats() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '/dashboard/stats',
    );
    final dynamic raw = response.data;

    Map<String, dynamic> stats = <String, dynamic>{};
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic> &&
          (raw['data'] as Map<String, dynamic>)['stats']
              is Map<String, dynamic>) {
        stats =
            (raw['data'] as Map<String, dynamic>)['stats']
                as Map<String, dynamic>;
      } else if (raw['stats'] is Map<String, dynamic>) {
        stats = raw['stats'] as Map<String, dynamic>;
      } else {
        stats = raw;
      }
    }

    return DashboardStats(
      totalOpd:
          stats['userTerdaftar'] as int? ?? stats['total_opd'] as int? ?? 0,
      selesai:
          stats['jumlahPenilaianSelesai'] as int? ??
          stats['selesai'] as int? ??
          0,
      progres:
          stats['jumlahPenilaianProgres'] as int? ??
          stats['progres'] as int? ??
          0,
    );
  }

  Future<List<OpdPerformance>> getOpdPerformance() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '/dashboard/performa-opd',
    );
    final List<dynamic> list = extractListData(response.data);

    return list.map((e) {
      if (e is Map<String, dynamic>) {
        return OpdPerformance(
          opdName: (e['nama'] ?? e['opd_name'] ?? 'Unknown').toString(),
          score: (e['nilai_koreksi_akhir'] ?? e['score'] as num? ?? 0.0)
              .toDouble(),
        );
      }
      return const OpdPerformance(opdName: 'Unknown', score: 0.0);
    }).toList();
  }

  Future<List<OpdDashboardProgress>> getOpdProgressData() async {
    final page = await getOpdProgressPage();
    return page.items;
  }

  Future<PaginatedResponse<OpdDashboardProgress>> getOpdProgressPage({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get<dynamic>(
      '/dashboard/progress-penilaian',
      queryParameters: <String, dynamic>{'page': page, 'per_page': perPage},
    );

    return parseLaravelPaginatedResponse(
      response.data,
      OpdDashboardProgress.fromJson,
      label: 'getOpdProgressPage',
    );
  }

  Future<List<WalidataDashboardProgress>> getWalidataProgressData() async {
    final response = await _dio.get<dynamic>('/dashboard/stats');
    final dynamic raw = response.data;

    Map<String, dynamic> dataMap = <String, dynamic>{};
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        dataMap = raw['data'] as Map<String, dynamic>;
      } else {
        dataMap = raw;
      }
    }

    final dynamic progressData = dataMap['progress_data'];
    final List<dynamic> list = (progressData is List) ? progressData : const [];

    return list.map((e) {
      if (e is Map<String, dynamic>) {
        return WalidataDashboardProgress.fromJson(e);
      }
      throw const FormatException('Invalid progress data format for Walidata');
    }).toList();
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dioProvider));
});
