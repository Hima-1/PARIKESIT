import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';
import 'package:parikesit/core/utils/base_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

abstract class IAssessmentRepository {
  Future<List<AssessmentFormModel>> getActivities();
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  });
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => getCompletedActivities(query: query);
  Future<AssessmentFormModel> getFormulir(int id);
  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  });
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async => throw UnimplementedError();
  Future<void> deleteActivity(int formulirId) async =>
      throw UnimplementedError();
  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  );
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  );
  Future<Penilaian> submitWalidataCorrection(
    int assessmentId,
    Map<String, dynamic> data,
  );
  Future<Penilaian> submitAdminEvaluation(
    int assessmentId,
    Map<String, dynamic> data,
  );
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId);
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  );
  Future<BuktiDukung> uploadBuktiDukung(int penilaianId, String filePath);

  Future<List<OpdModel>> getOpdsForActivity(String activityId);
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async =>
      getOpdsForActivity(activityId);
  Future<List<ComparisonSummaryModel>> getComparisonSummary(String activityId);
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  );
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  );
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId);
  Future<Map<String, RoleScore>> getOpdDomainScores(int activityId, int opdId);

  /// Load penilaian milik user yang sedang login untuk formulir tertentu.
  /// Mengembalikan tuple (formulir, map dari indikatorId → Penilaian).
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  );
}

typedef AssessmentRepository = IAssessmentRepository;

extension AssessmentRepositoryPagination on IAssessmentRepository {
  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async {
    final IAssessmentRepository repository = this;
    if (repository is AssessmentRepositoryImpl) {
      return repository.getActivitiesPage(page: page, perPage: perPage);
    }

    final List<AssessmentFormModel> activities = await getActivities();
    return PaginatedResponse<AssessmentFormModel>(
      data: activities,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: activities.length,
        from: activities.isEmpty ? null : 1,
        to: activities.isEmpty ? null : activities.length,
        path: '/formulir',
      ),
      links: const PaginationLinks(
        first: '/formulir?page=1',
        last: '/formulir?page=1',
      ),
    );
  }

  Future<PaginatedResponse<OpdModel>> getOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final IAssessmentRepository repository = this;
    if (repository is AssessmentRepositoryImpl) {
      return repository.getOpdsForActivityPage(
        activityId,
        page: page,
        perPage: perPage,
      );
    }

    final List<OpdModel> opds = await getOpdsForActivity(activityId);
    return PaginatedResponse<OpdModel>(
      data: opds,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: opds.length,
        from: opds.isEmpty ? null : 1,
        to: opds.isEmpty ? null : opds.length,
        path: '/penilaian-selesai/$activityId/opds',
      ),
      links: PaginationLinks(
        first: '/penilaian-selesai/$activityId/opds?page=1',
        last: '/penilaian-selesai/$activityId/opds?page=1',
      ),
    );
  }

  Future<PaginatedResponse<OpdModel>> getPublicOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final IAssessmentRepository repository = this;
    if (repository is AssessmentRepositoryImpl) {
      return repository.getPublicOpdsForActivityPage(
        activityId,
        page: page,
        perPage: perPage,
      );
    }

    final List<OpdModel> opds = await getPublicOpdsForActivity(activityId);
    return PaginatedResponse<OpdModel>(
      data: opds,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: opds.length,
        from: opds.isEmpty ? null : 1,
        to: opds.isEmpty ? null : opds.length,
        path: '/public/penilaian-selesai/$activityId/opds',
      ),
      links: PaginationLinks(
        first: '/public/penilaian-selesai/$activityId/opds?page=1',
        last: '/public/penilaian-selesai/$activityId/opds?page=1',
      ),
    );
  }
}

class AssessmentRepositoryImpl extends BaseRepository
    implements IAssessmentRepository {
  AssessmentRepositoryImpl(this._client);

  final Dio _client;

  @override
  Future<List<AssessmentFormModel>> getActivities() async {
    final PaginatedResponse<AssessmentFormModel> page =
        await getActivitiesPage();
    return page.items;
  }

  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async {
    final Response<dynamic> response = await _client.get(
      '/formulir',
      queryParameters: <String, dynamic>{'page': page, 'per_page': perPage},
    );
    return parseLaravelPaginatedResponse(
      response.data,
      _mapFormulir,
      label: 'getActivitiesPage',
    );
  }

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async {
    return safeRequest(() async {
      final Response<dynamic> response = await _client.get(
        '/penilaian-selesai',
        queryParameters: query.toQueryParameters(),
      );
      return parseLaravelPaginatedResponse(
        response.data,
        _mapFormulir,
        label: 'getCompletedActivities',
      );
    }, label: 'getCompletedActivities');
  }

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async {
    return safeRequest(() async {
      final Response<dynamic> response = await _client.get(
        '/public/penilaian-selesai',
        queryParameters: query.toQueryParameters(),
      );
      return parseLaravelPaginatedResponse(
        response.data,
        _mapFormulir,
        label: 'getPublicCompletedActivities',
      );
    }, label: 'getPublicCompletedActivities');
  }

  @override
  Future<AssessmentFormModel> getFormulir(int id) async {
    final Response<dynamic> response = await _client.get('/formulir/$id');
    final Map<String, dynamic> data = _extractMapData(response.data);
    return _mapFormulir(data);
  }

  @override
  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  }) async {
    final Response<dynamic> response = await _client.post<dynamic>(
      '/formulir',
      data: <String, dynamic>{
        'nama_formulir': activity.title,
        'tanggal_dibuat': activity.date.toIso8601String(),
        'use_template': useTemplate,
      },
    );
    return _mapFormulir(_extractMapData(response.data));
  }

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    final Response<dynamic> response = await _client.patch<dynamic>(
      '/formulir/$formulirId',
      data: <String, dynamic>{'nama_formulir': name},
    );
    return _mapFormulir(_extractMapData(response.data));
  }

  @override
  Future<void> deleteActivity(int formulirId) async {
    await _client.delete<dynamic>('/formulir/$formulirId');
  }

  @override
  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {
    await _client.post<dynamic>(
      '/formulir/$activityId/domains',
      data: <String, dynamic>{'nama_domain': domainName, 'nama_aspek': aspects},
    );
  }

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async {
    // Endpoint aktif: POST /formulir/{formulirId}/indikator/{indikatorId}/penilaian.
    // Hanya kirim field yang memang dipakai API Laravel saat ini.
    final Map<String, dynamic> payload = Map<String, dynamic>.from(data)
      ..remove('formulir_id')
      ..remove('indikator_id')
      ..remove('status');
    final String? evidenceFilePath =
        payload.remove('bukti_dukung_file_path') as String?;
    final Object? rawEvidencePaths = payload.remove('bukti_dukung_file_paths');
    final List<String> evidenceFilePaths = <String>[
      if (evidenceFilePath != null && evidenceFilePath.isNotEmpty)
        evidenceFilePath,
      if (rawEvidencePaths is List)
        ...rawEvidencePaths.whereType<String>().where(
          (String path) => path.isNotEmpty,
        ),
    ];
    final Object requestData;
    if (evidenceFilePaths.isNotEmpty) {
      final FormData formData = FormData();
      for (final MapEntry<String, dynamic> entry in payload.entries) {
        formData.fields.add(MapEntry(entry.key, entry.value?.toString() ?? ''));
      }
      for (final String path in evidenceFilePaths) {
        formData.files.add(
          MapEntry('bukti_dukung[]', await MultipartFile.fromFile(path)),
        );
      }
      requestData = formData;
    } else {
      requestData = payload;
    }
    final Response<dynamic> response = await _client.post<dynamic>(
      '/formulir/$formulirId/indikator/$indikatorId/penilaian',
      data: requestData,
    );
    final Map<String, dynamic> result = _extractMapData(response.data);
    return Penilaian.fromJson(result);
  }

  @override
  Future<Penilaian> submitWalidataCorrection(
    int assessmentId,
    Map<String, dynamic> data,
  ) async {
    final Map<String, dynamic> payload = Map<String, dynamic>.from(data);
    // Align with docs: POST /api/penilaian-selesai/koreksi
    final Response<dynamic> response = await _client.post<dynamic>(
      '/penilaian-selesai/koreksi',
      data: payload,
    );
    final Map<String, dynamic> result = _extractMapData(response.data);
    return Penilaian.fromJson(result);
  }

  @override
  Future<Penilaian> submitAdminEvaluation(
    int assessmentId,
    Map<String, dynamic> data,
  ) async {
    final Map<String, dynamic> payload = Map<String, dynamic>.from(data);
    // Align with docs: POST /api/penilaian-selesai/evaluasi
    final Response<dynamic> response = await _client.post<dynamic>(
      '/penilaian-selesai/evaluasi',
      data: payload,
    );
    final Map<String, dynamic> result = _extractMapData(response.data);
    return Penilaian.fromJson(result);
  }

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async {
    final Response<dynamic> response = await _client.post(
      '/bukti-dukungs',
      data: FormData.fromMap(<String, dynamic>{
        'penilaian_id': penilaianId,
        'file': await MultipartFile.fromFile(filePath),
      }),
      options: Options(contentType: 'multipart/form-data'),
    );
    final Map<String, dynamic> payload = _extractMapData(response.data);
    return BuktiDukung.fromJson(payload);
  }

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async {
    final Response<dynamic> response = await _client.get<dynamic>(
      '/formulir/$formulirId/disposisis',
    );
    final List<dynamic> data = _extractListData(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(AssessmentDisposisi.fromJson)
        .toList(growable: false);
  }

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async {
    final Response<dynamic> response = await _client.post<dynamic>(
      '/formulir/$formulirId/disposisis',
      data: data,
    );
    final Map<String, dynamic> payload = _extractMapData(response.data);
    return AssessmentDisposisi.fromJson(payload);
  }

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async {
    final PaginatedResponse<OpdModel> page = await getOpdsForActivityPage(
      activityId,
    );
    return page.items;
  }

  Future<PaginatedResponse<OpdModel>> getOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai/$activityId/opds',
      queryParameters: <String, dynamic>{'page': page, 'per_page': perPage},
    );
    return parseLaravelPaginatedResponse(
      response.data,
      OpdModel.fromJson,
      label: 'getOpdsForActivityPage',
    );
  }

  @override
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async {
    final PaginatedResponse<OpdModel> page = await getPublicOpdsForActivityPage(
      activityId,
    );
    return page.items;
  }

  Future<PaginatedResponse<OpdModel>> getPublicOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final Response<dynamic> response = await _client.get(
      '/public/penilaian-selesai/$activityId/opds',
      queryParameters: <String, dynamic>{'page': page, 'per_page': perPage},
    );
    return parseLaravelPaginatedResponse(
      response.data,
      OpdModel.fromJson,
      label: 'getPublicOpdsForActivityPage',
    );
  }

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai/$activityId/summary',
    );
    final List<dynamic> data = _extractListData(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(_mapComparisonSummary)
        .toList(growable: false);
  }

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai/$activityId/opd/$opdId/stats',
    );
    final dynamic data = response.data;
    final Map<String, dynamic> body = data is Map<String, dynamic>
        ? data
        : const <String, dynamic>{};
    final dynamic comparison = body['comparison'];
    if (comparison is Map<String, dynamic>) {
      return <String, double?>{
        'opd': _parseNullableDouble(comparison['opd_score']),
        'walidata': _parseNullableDouble(comparison['walidata_score']),
        'admin': _parseNullableDouble(comparison['admin_score']),
      };
    }
    return <String, double?>{'opd': null, 'walidata': null, 'admin': null};
  }

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai/$activityId/opd/$opdId/domains',
    );
    final List<dynamic> data = _extractListData(response.data);
    final Map<String, RoleScore> result = <String, RoleScore>{};

    for (final Map<String, dynamic> item
        in data.whereType<Map<String, dynamic>>()) {
      final String domainId = item['domain_id']?.toString() ?? '';
      if (domainId.isEmpty) continue;
      result[domainId] = RoleScore(
        opd: _parseNullableDouble(item['opd_score']),
        walidata: _parseNullableDouble(item['walidata_score']),
        admin: _parseNullableDouble(item['admin_score']),
      );
    }

    return result;
  }

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async {
    // Endpoint /formulir/{id}/indicators mengembalikan:
    // { data: { id, nama_formulir, created_at, updated_at, domains: [...] } }
    // dengan setiap indikator embed 'penilaian' milik auth user.
    final Response<dynamic> response = await _client.get<dynamic>(
      '/formulir/$formulirId/indicators',
    );
    final dynamic raw = response.data;
    // Ambil objek formulir dari data
    final dynamic dataRaw = raw is Map<String, dynamic> ? raw['data'] : raw;
    final Map<String, dynamic> formulirMap = dataRaw is Map<String, dynamic>
        ? dataRaw
        : <String, dynamic>{};

    // Parse metadata formulir sekaligus
    return _parseAssessmentTreeWithDrafts(formulirMap);
  }

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async {
    // Endpoint /indicators mengembalikan:
    // { data: { id, nama_formulir, created_at, updated_at, domains: [...] } }
    final Response<dynamic> response = await _client.get(
      '/formulir/$activityId/indicators',
      queryParameters: {'user_id': opdId},
    );

    final dynamic raw = response.data;
    final dynamic dataRaw = raw is Map<String, dynamic> ? raw['data'] : raw;
    final Map<String, dynamic> formulirMap = dataRaw is Map<String, dynamic>
        ? dataRaw
        : <String, dynamic>{};

    return _parseAssessmentTreeWithDrafts(formulirMap);
  }

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/public/penilaian-selesai/$activityId/opd/$opdId',
    );
    final Map<String, dynamic> formulirMap = _extractMapData(response.data);

    return _parseAssessmentTreeWithDrafts(formulirMap);
  }

  AssessmentFormModel _mapFormulir(Map<String, dynamic> item) {
    final List<dynamic> domainsRaw =
        item['domains'] as List<dynamic>? ??
        item['formulir_domains'] as List<dynamic>? ??
        const <dynamic>[];
    final List<DomainModel> domains = domainsRaw
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> domainRaw) {
          final Map<String, dynamic> source =
              domainRaw['domain'] is Map<String, dynamic>
              ? domainRaw['domain'] as Map<String, dynamic>
              : domainRaw;
          final String domainName =
              source['nama_domain']?.toString() ??
              source['name']?.toString() ??
              'Domain';

          final List<dynamic> aspectsRaw =
              source['aspek'] as List<dynamic>? ??
              source['aspeks'] as List<dynamic>? ??
              const <dynamic>[];

          final List<AspectModel>
          aspects = aspectsRaw.whereType<Map<String, dynamic>>().map((
            Map<String, dynamic> aspectRaw,
          ) {
            final List<dynamic> indicatorsRaw =
                aspectRaw['indikator'] as List<dynamic>? ??
                aspectRaw['indicators'] as List<dynamic>? ??
                const <dynamic>[];

            final List<IndicatorModel>
            indicators = indicatorsRaw.whereType<Map<String, dynamic>>().map((
              Map<String, dynamic> indicatorRaw,
            ) {
              final dynamic penilaianRaw = indicatorRaw['penilaian'];
              RoleScore? score;

              final Map<String, dynamic>? p = _resolveFilledPenilaianMap(
                penilaianRaw,
                requiredField: 'nilai',
              );

              if (p != null) {
                score = RoleScore(
                  opd: _parseNullableDouble(p['nilai']),
                  walidata: _parseNullableDouble(p['nilai_diupdate']),
                  admin: _parseNullableDouble(p['nilai_koreksi']),
                );
              } else if (penilaianRaw is Map<String, dynamic>) {
                score = RoleScore(
                  opd: _parseNullableDouble(penilaianRaw['nilai']),
                  walidata: _parseNullableDouble(
                    penilaianRaw['nilai_diupdate'],
                  ),
                  admin: _parseNullableDouble(penilaianRaw['nilai_koreksi']),
                );
              }

              return IndicatorModel(
                id: indicatorRaw['id']?.toString() ?? '',
                kodeIndikator: indicatorRaw['kode_indikator']?.toString(),
                name:
                    indicatorRaw['nama_indikator']?.toString() ??
                    indicatorRaw['name']?.toString() ??
                    '',
                bobotIndikator:
                    _parseNullableDouble(indicatorRaw['bobot_indikator']) ?? 0,
                level1Kriteria: indicatorRaw['level_1_kriteria']?.toString(),
                level2Kriteria: indicatorRaw['level_2_kriteria']?.toString(),
                level3Kriteria: indicatorRaw['level_3_kriteria']?.toString(),
                level4Kriteria: indicatorRaw['level_4_kriteria']?.toString(),
                level5Kriteria: indicatorRaw['level_5_kriteria']?.toString(),
                level1Kriteria10101: indicatorRaw['level_1_kriteria_10101']
                    ?.toString(),
                level2Kriteria10101: indicatorRaw['level_2_kriteria_10101']
                    ?.toString(),
                level3Kriteria10101: indicatorRaw['level_3_kriteria_10101']
                    ?.toString(),
                level4Kriteria10101: indicatorRaw['level_4_kriteria_10101']
                    ?.toString(),
                level5Kriteria10101: indicatorRaw['level_5_kriteria_10101']
                    ?.toString(),
                level1Kriteria10201: indicatorRaw['level_1_kriteria_10201']
                    ?.toString(),
                level2Kriteria10201: indicatorRaw['level_2_kriteria_10201']
                    ?.toString(),
                level3Kriteria10201: indicatorRaw['level_3_kriteria_10201']
                    ?.toString(),
                level4Kriteria10201: indicatorRaw['level_4_kriteria_10201']
                    ?.toString(),
                level5Kriteria10201: indicatorRaw['level_5_kriteria_10201']
                    ?.toString(),
                scores: score,
              );
            }).toList();

            return AspectModel(
              id: aspectRaw['id']?.toString() ?? '',
              name:
                  aspectRaw['nama_aspek']?.toString() ??
                  aspectRaw['name']?.toString() ??
                  '',
              indicators: indicators,
              scores: _mapRoleScore(aspectRaw),
            );
          }).toList();

          return DomainModel(
            id:
                source['id']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: domainName,
            date: _parseDateTime(source['updated_at']),
            aspects: aspects,
            indicatorCount: aspects.fold(
              0,
              (sum, a) => sum + a.indicators.length,
            ),
            scores: _mapRoleScore(source),
          );
        })
        .toList(growable: false);

    return AssessmentFormModel(
      id:
          item['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          item['nama_formulir']?.toString() ?? item['title']?.toString() ?? '-',
      date: _parseDateTime(item['tanggal_dibuat'] ?? item['created_at']),
      domains: domains,
      scores: _mapRoleScore(item),
      reviewProgress: _mapReviewProgress(item['review_progress']),
    );
  }

  ReviewProgressSummary? _mapReviewProgress(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    final List<PendingIndicatorPreview> pendingIndicatorPreview =
        (raw['pending_indicator_preview'] as List<dynamic>? ??
                const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(PendingIndicatorPreview.fromJson)
            .toList(growable: false);

    return ReviewProgressSummary(
      totalIndicators: _parseInt(raw['total_indicators']),
      correctedCount: _parseInt(raw['corrected_count']),
      percentage: _parseNullableDouble(raw['percentage']) ?? 0,
      finalCorrectionScore: _parseNullableDouble(raw['final_correction_score']),
      pendingIndicatorPreview: pendingIndicatorPreview,
    );
  }

  RoleScore? _mapRoleScore(Map<String, dynamic> json) {
    final dynamic scoresRaw =
        json['scores'] ?? json['comparison'] ?? json['penilaian'];
    if (scoresRaw is Map<String, dynamic>) {
      return RoleScore(
        opd: _parseNullableDouble(
          scoresRaw['opd'] ?? scoresRaw['opd_score'] ?? scoresRaw['nilai'],
        ),
        walidata: _parseNullableDouble(
          scoresRaw['walidata'] ??
              scoresRaw['walidata_score'] ??
              scoresRaw['nilai_diupdate'],
        ),
        admin: _parseNullableDouble(
          scoresRaw['admin'] ??
              scoresRaw['admin_score'] ??
              scoresRaw['nilai_koreksi'],
        ),
      );
    } else if (scoresRaw is List && scoresRaw.isNotEmpty) {
      final Map<String, dynamic>? p = _resolveFilledPenilaianMap(
        scoresRaw,
        requiredField: 'nilai',
      );
      if (p != null) {
        return RoleScore(
          opd: _parseNullableDouble(p['nilai']),
          walidata: _parseNullableDouble(p['nilai_diupdate']),
          admin: _parseNullableDouble(p['nilai_koreksi']),
        );
      }
    }
    return null;
  }

  Map<String, dynamic>? _resolveFilledPenilaianMap(
    dynamic penilaianRaw, {
    required String requiredField,
  }) {
    if (penilaianRaw is Map<String, dynamic>) {
      return _isFieldFilled(penilaianRaw, requiredField) ? penilaianRaw : null;
    }

    if (penilaianRaw is List) {
      final List<Map<String, dynamic>> candidates = penilaianRaw
          .whereType<Map<String, dynamic>>()
          .where(
            (Map<String, dynamic> item) => _isFieldFilled(item, requiredField),
          )
          .toList(growable: false);

      if (candidates.isEmpty) {
        return null;
      }

      candidates.sort(
        (Map<String, dynamic> a, Map<String, dynamic> b) =>
            _comparePenilaianMap(b, a),
      );
      return candidates.first;
    }

    return null;
  }

  (AssessmentFormModel, Map<int, Penilaian>) _parseAssessmentTreeWithDrafts(
    Map<String, dynamic> formulirMap,
  ) {
    final AssessmentFormModel model = _mapFormulir(formulirMap);
    final Map<int, Penilaian> assessments = <int, Penilaian>{};
    final List<dynamic> domainsRaw =
        formulirMap['domains'] as List<dynamic>? ?? const <dynamic>[];

    for (final dynamic domainRaw in domainsRaw) {
      final Map<String, dynamic> domain = domainRaw as Map<String, dynamic>;
      final List<dynamic> aspectsRaw =
          domain['aspek'] as List<dynamic>? ??
          domain['aspeks'] as List<dynamic>? ??
          const <dynamic>[];

      for (final dynamic aspectRaw in aspectsRaw) {
        final Map<String, dynamic> aspect = aspectRaw as Map<String, dynamic>;
        final List<dynamic> indicatorsRaw =
            aspect['indikator'] as List<dynamic>? ??
            aspect['indicators'] as List<dynamic>? ??
            const <dynamic>[];

        for (final dynamic indicatorRaw in indicatorsRaw) {
          final Map<String, dynamic> indicator =
              indicatorRaw as Map<String, dynamic>;
          final dynamic penilaianRaw = indicator['penilaian'];
          final Map<String, dynamic>? penilaianData =
              _resolveFilledPenilaianMap(penilaianRaw, requiredField: 'nilai');

          if (penilaianData != null) {
            final Penilaian penilaian = Penilaian.fromJson(penilaianData);
            assessments[penilaian.indikatorId] = penilaian;
          }
        }
      }
    }

    return (model, assessments);
  }

  bool _isFieldFilled(Map<String, dynamic> json, String field) {
    final dynamic value = json[field];

    if (field == 'evaluasi' ||
        field == 'catatan' ||
        field == 'catatan_koreksi') {
      return value is String ? value.trim().isNotEmpty : value != null;
    }

    if (field == 'bukti_dukung') {
      if (value is List) {
        return value.isNotEmpty;
      }
      return value != null && value.toString().isNotEmpty && value != '-';
    }

    if (value == null) {
      return false;
    }

    if (value is String) {
      return value.trim().isNotEmpty;
    }

    return true;
  }

  int _comparePenilaianMap(Map<String, dynamic> a, Map<String, dynamic> b) {
    final int updatedComparison = _compareNullableDateTime(
      a['updated_at'],
      b['updated_at'],
    );
    if (updatedComparison != 0) {
      return updatedComparison;
    }

    final int createdComparison = _compareNullableDateTime(
      a['created_at'],
      b['created_at'],
    );
    if (createdComparison != 0) {
      return createdComparison;
    }

    return _parseInt(a['id']).compareTo(_parseInt(b['id']));
  }

  int _compareNullableDateTime(dynamic a, dynamic b) {
    final DateTime? dateA = _parseNullableDateTime(a);
    final DateTime? dateB = _parseNullableDateTime(b);

    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return -1;
    if (dateB == null) return 1;
    return dateA.compareTo(dateB);
  }

  double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value == null) return DateTime.now();

    final String strValue = value.toString();
    if (strValue.isEmpty) return DateTime.now();

    return DateTime.tryParse(strValue) ?? DateTime.now();
  }

  DateTime? _parseNullableDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value == null) return null;

    final String strValue = value.toString();
    if (strValue.isEmpty) return null;

    return DateTime.tryParse(strValue);
  }

  ComparisonSummaryModel _mapComparisonSummary(Map<String, dynamic> item) {
    return ComparisonSummaryModel(
      opdId:
          (item['opd_id'] as num?)?.toInt() ??
          (item['id'] as num?)?.toInt() ??
          0,
      opdName:
          item['nama_opd']?.toString() ?? item['name']?.toString() ?? 'OPD',
      skorMandiri:
          _parseNullableDouble(item['skor_mandiri'] ?? item['opd_score']) ?? 0,
      skorWalidata:
          _parseNullableDouble(
            item['skor_walidata'] ?? item['walidata_score'],
          ) ??
          0,
      skorBps:
          _parseNullableDouble(item['skor_bps'] ?? item['admin_score']) ?? 0,
    );
  }

  List<dynamic> _extractListData(dynamic responseData) {
    if (responseData is List<dynamic>) {
      return responseData;
    }
    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];
      if (data is List<dynamic>) {
        return data;
      }
    }
    return const <dynamic>[];
  }

  Map<String, dynamic> _extractMapData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return responseData;
    }
    throw StateError('Unexpected API response format');
  }
}

final assessmentRepositoryProvider = Provider<IAssessmentRepository>((ref) {
  final Dio client = ref.watch(dioProvider);
  return AssessmentRepositoryImpl(client);
});
