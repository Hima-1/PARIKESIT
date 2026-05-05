import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/laravel_response.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/network/providers/dio_provider.dart';
import '../../domain/dashboard_stats.dart';
import '../../domain/opd_dashboard_progress.dart';
import '../../domain/opd_performance.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/walidata_dashboard_progress.dart';
import '../data_sources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  DashboardRepositoryImpl(this._dataSource, this._dio);
  final DashboardRemoteDataSource _dataSource;
  final Dio _dio;

  @override
  Future<DashboardStats> getDashboardStats() async {
    final response = await _dataSource.getDashboardStats();
    final dynamic rawResponse = response.data;

    Map<String, dynamic> stats = {};

    if (rawResponse is Map<String, dynamic>) {
      if (rawResponse['data'] is Map<String, dynamic> &&
          (rawResponse['data'] as Map<String, dynamic>)['stats']
              is Map<String, dynamic>) {
        stats =
            (rawResponse['data'] as Map<String, dynamic>)['stats']
                as Map<String, dynamic>;
      } else if (rawResponse['stats'] is Map<String, dynamic>) {
        stats = rawResponse['stats'] as Map<String, dynamic>;
      } else {
        stats = rawResponse;
      }
    }

    // Map backend names to model names with safe fallbacks
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

  @override
  Future<List<OpdPerformance>> getOpdPerformance() async {
    final response = await _dataSource.getOpdPerformance();
    final dynamic rawData = response.data;

    final List<dynamic> list = (rawData is List)
        ? rawData
        : (rawData is Map && rawData['data'] is List
              ? rawData['data'] as List
              : []);

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

  @override
  Future<List<OpdDashboardProgress>> getOpdProgressData() async {
    final page = await getOpdProgressPage();
    return page.items;
  }

  @override
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

  @override
  Future<List<WalidataDashboardProgress>> getWalidataProgressData() async {
    final response = await _dataSource.getDashboardStats();
    final dynamic rawData = response.data;

    // The data might be inside 'data' or directly in the response
    Map<String, dynamic> dataMap = {};
    if (rawData is Map<String, dynamic>) {
      if (rawData['data'] is Map<String, dynamic>) {
        dataMap = rawData['data'] as Map<String, dynamic>;
      } else {
        dataMap = rawData;
      }
    }

    final dynamic progressData = dataMap['progress_data'];

    final List<dynamic> list = (progressData is List) ? progressData : [];

    return list.map((e) {
      if (e is Map<String, dynamic>) {
        return WalidataDashboardProgress.fromJson(e);
      }
      throw const FormatException('Invalid progress data format for Walidata');
    }).toList();
  }
}

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return DashboardRemoteDataSource(dio);
});

final dashboardRepositoryProvider = Provider<IDashboardRepository>((ref) {
  final dataSource = ref.watch(dashboardRemoteDataSourceProvider);
  final dio = ref.watch(dioProvider);
  return DashboardRepositoryImpl(dataSource, dio);
});
