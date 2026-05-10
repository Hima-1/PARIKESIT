import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';
import '../domain/admin_assessment_progress.dart';
import '../domain/admin_assessment_progress_query.dart';
import '../domain/paged_admin_assessment_progress.dart';

class AdminDashboardStats {
  AdminDashboardStats({
    required this.totalOpd,
    required this.totalKegiatan,
    required this.averageScore,
    required this.progressDistribution,
    required this.assessmentProgress,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    // Map Laravel keys from DashboardService.php / DashboardStatsResource.php
    final stats = json['stats'] as Map<String, dynamic>? ?? {};

    return AdminDashboardStats(
      totalOpd: stats['userTerdaftar'] as int? ?? 0,
      totalKegiatan: stats['jumlahKegiatanPenilaian'] as int? ?? 0,
      averageScore: (stats['average_score'] as num?)?.toDouble() ?? 0.0,
      progressDistribution: _parseProgressDistribution(
        stats['progress_distribution'] ?? json['progress_distribution'],
      ),
      assessmentProgress: _parseAssessmentProgress(
        stats['progress_assessments'] ?? json['progress_assessments'],
      ),
    );
  }

  final int totalOpd;
  final int totalKegiatan;
  final double averageScore;
  final Map<String, double> progressDistribution;
  final List<AdminAssessmentProgress> assessmentProgress;
}

Map<String, double> _parseProgressDistribution(dynamic raw) {
  if (raw is Map) {
    return raw.map(
      (k, v) => MapEntry(k.toString(), (v as num?)?.toDouble() ?? 0.0),
    );
  }

  // Some backends return an array of items instead of a map.
  // Try to coerce formats like:
  // [{"key":"belum","value":30}, {"key":"proses","value":50}]
  if (raw is List) {
    final out = <String, double>{};
    for (final item in raw) {
      if (item is Map) {
        final key = (item['key'] ?? item['status'] ?? item['label'] ?? '')
            .toString();
        if (key.isEmpty) continue;
        final value = (item['value'] ?? item['count'] ?? item['percent']);
        out[key] = (value as num?)?.toDouble() ?? 0.0;
      }
    }
    return out;
  }

  return <String, double>{};
}

List<AdminAssessmentProgress> _parseAssessmentProgress(dynamic raw) {
  if (raw is List) {
    return raw.whereType<Map<String, dynamic>>().map((item) {
      final opd = item['statistik_opd'] as Map<String, dynamic>? ?? {};
      final walidata =
          item['statistik_walidata'] as Map<String, dynamic>? ?? {};

      return AdminAssessmentProgress.fromJson({
        ...item,
        'opd_filled_count': opd['terisi'] ?? item['opd_filled_count'] ?? 0,
        'opd_total_count':
            opd['total_indikator'] ?? item['opd_total_count'] ?? 0,
        'walidata_corrected_count':
            walidata['terkoreksi'] ?? item['walidata_corrected_count'] ?? 0,
        'walidata_total_count':
            walidata['total_indikator'] ?? item['walidata_total_count'] ?? 0,
      });
    }).toList();
  }
  return [];
}

class AdminDashboardRepository {
  AdminDashboardRepository(this._dio);
  final Dio _dio;

  Future<AdminDashboardStats> getStatistics() async {
    final futures = await Future.wait([
      _dio.get<dynamic>('/dashboard/stats'),
      _dio.get<dynamic>('/dashboard/progress-penilaian'),
    ]);

    final statsResponse = futures[0];
    final progressResponse = futures[1];

    final statsRoot = statsResponse.data;
    if (statsRoot is! Map<String, dynamic>) {
      throw const FormatException(
        'Unexpected response shape for /dashboard/stats',
      );
    }

    final statsData = statsRoot['data'];
    if (statsData is! Map<String, dynamic>) {
      throw const FormatException('Unexpected data shape for /dashboard/stats');
    }

    final progressRoot = progressResponse.data;
    List<AdminAssessmentProgress> assessmentProgress = [];

    if (progressRoot is Map<String, dynamic> && progressRoot['data'] is List) {
      assessmentProgress = _parseAssessmentProgress(progressRoot['data']);
    } else if (progressRoot is List) {
      assessmentProgress = _parseAssessmentProgress(progressRoot);
    }

    final stats = statsData['stats'] as Map<String, dynamic>? ?? {};
    return AdminDashboardStats(
      totalOpd: stats['userTerdaftar'] as int? ?? 0,
      totalKegiatan: stats['jumlahKegiatanPenilaian'] as int? ?? 0,
      averageScore: (stats['average_score'] as num?)?.toDouble() ?? 0.0,
      progressDistribution: _parseProgressDistribution(
        stats['progress_distribution'] ?? statsData['progress_distribution'],
      ),
      assessmentProgress: assessmentProgress.isNotEmpty
          ? assessmentProgress
          : _parseAssessmentProgress(
              stats['progress_assessments'] ??
                  statsData['progress_assessments'],
            ),
    );
  }

  Future<PagedAdminAssessmentProgress> getAssessmentProgressPage(
    AdminAssessmentProgressQuery query,
  ) async {
    final response = await _dio.get<dynamic>(
      '/dashboard/progress-penilaian',
      queryParameters: query.toQueryParameters(),
    );

    final root = response.data;
    if (root is! Map<String, dynamic>) {
      throw const FormatException(
        'Unexpected response shape for /dashboard/progress-penilaian',
      );
    }

    final items = _parseAssessmentProgress(root['data']);
    final meta = root['meta'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return PagedAdminAssessmentProgress(
      items: items,
      currentPage: meta['current_page'] as int? ?? query.page,
      lastPage: meta['last_page'] as int? ?? 1,
      perPage: meta['per_page'] as int? ?? query.perPage,
      total: meta['total'] as int? ?? items.length,
    );
  }
}

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return AdminDashboardRepository(dio);
});
