import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';
import 'package:parikesit/features/assessment/data/assessment_mappers.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

class AssessmentRepository {
  AssessmentRepository(this._client);

  final Dio _client;

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
      mapFormulir,
      label: 'getActivitiesPage',
    );
  }

  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai',
      queryParameters: query.toQueryParameters(),
    );
    return parseLaravelPaginatedResponse(
      response.data,
      mapFormulir,
      label: 'getCompletedActivities',
    );
  }

  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async {
    final Response<dynamic> response = await _client.get(
      '/public/penilaian-selesai',
      queryParameters: query.toQueryParameters(),
    );
    return parseLaravelPaginatedResponse(
      response.data,
      mapFormulir,
      label: 'getPublicCompletedActivities',
    );
  }

  Future<AssessmentFormModel> getFormulir(int id) async {
    final Response<dynamic> response = await _client.get('/formulir/$id');
    final Map<String, dynamic> data = extractMapData(response.data);
    return mapFormulir(data);
  }

  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  }) async {
    final Response<dynamic> response = await _client.post<dynamic>(
      '/formulir',
      data: <String, dynamic>{
        'nama_formulir': InputSanitizer.trimPlainText(
          activity.title,
          maxLength: 255,
        ),
        'tanggal_dibuat': activity.date.toIso8601String(),
        'use_template': useTemplate,
      },
    );
    return mapFormulir(extractMapData(response.data));
  }

  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    final Response<dynamic> response = await _client.patch<dynamic>(
      '/formulir/$formulirId',
      data: <String, dynamic>{
        'nama_formulir': InputSanitizer.trimPlainText(name, maxLength: 255),
      },
    );
    return mapFormulir(extractMapData(response.data));
  }

  Future<void> deleteActivity(int formulirId) async {
    await _client.delete<dynamic>('/formulir/$formulirId');
  }

  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {
    await _client.post<dynamic>(
      '/formulir/$activityId/domains',
      data: <String, dynamic>{
        'nama_domain': InputSanitizer.trimPlainText(domainName, maxLength: 255),
        'nama_aspek': aspects
            .map((value) => InputSanitizer.trimPlainText(value, maxLength: 255))
            .where((value) => value.isNotEmpty)
            .toList(growable: false),
      },
    );
  }

  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async {
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
    final Map<String, dynamic> result = extractMapData(response.data);
    return Penilaian.fromJson(result);
  }

  Future<Penilaian> submitWalidataCorrection(Map<String, dynamic> data) async {
    final Response<dynamic> response = await _client.post<dynamic>(
      '/penilaian-selesai/koreksi',
      data: data,
    );
    return Penilaian.fromJson(extractMapData(response.data));
  }

  Future<Penilaian> submitAdminEvaluation(Map<String, dynamic> data) async {
    final Response<dynamic> response = await _client.post<dynamic>(
      '/penilaian-selesai/evaluasi',
      data: data,
    );
    return Penilaian.fromJson(extractMapData(response.data));
  }

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
    final Map<String, dynamic> payload = extractMapData(response.data);
    return BuktiDukung.fromJson(payload);
  }

  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async {
    final Response<dynamic> response = await _client.get<dynamic>(
      '/formulir/$formulirId/disposisis',
    );
    final List<dynamic> data = extractListData(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(AssessmentDisposisi.fromJson)
        .toList(growable: false);
  }

  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async {
    final Response<dynamic> response = await _client.post<dynamic>(
      '/formulir/$formulirId/disposisis',
      data: data,
    );
    final Map<String, dynamic> payload = extractMapData(response.data);
    return AssessmentDisposisi.fromJson(payload);
  }

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

  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai/$activityId/summary',
    );
    final List<dynamic> data = extractListData(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(mapComparisonSummary)
        .toList(growable: false);
  }

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
        'opd': parseNullableDouble(comparison['opd_score']),
        'walidata': parseNullableDouble(comparison['walidata_score']),
        'admin': parseNullableDouble(comparison['admin_score']),
      };
    }
    return <String, double?>{'opd': null, 'walidata': null, 'admin': null};
  }

  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/penilaian-selesai/$activityId/opd/$opdId/domains',
    );
    final List<dynamic> data = extractListData(response.data);
    final Map<String, RoleScore> result = <String, RoleScore>{};

    for (final Map<String, dynamic> item
        in data.whereType<Map<String, dynamic>>()) {
      final String domainId = item['domain_id']?.toString() ?? '';
      if (domainId.isEmpty) continue;
      result[domainId] = RoleScore(
        opd: parseNullableDouble(item['opd_score']),
        walidata: parseNullableDouble(item['walidata_score']),
        admin: parseNullableDouble(item['admin_score']),
      );
    }

    return result;
  }

  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async {
    final Response<dynamic> response = await _client.get<dynamic>(
      '/formulir/$formulirId/indicators',
    );
    final dynamic raw = response.data;
    final dynamic dataRaw = raw is Map<String, dynamic> ? raw['data'] : raw;
    final Map<String, dynamic> formulirMap = dataRaw is Map<String, dynamic>
        ? dataRaw
        : <String, dynamic>{};
    return parseAssessmentTreeWithDrafts(formulirMap);
  }

  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/formulir/$activityId/indicators',
      queryParameters: {'user_id': opdId},
    );

    final dynamic raw = response.data;
    final dynamic dataRaw = raw is Map<String, dynamic> ? raw['data'] : raw;
    final Map<String, dynamic> formulirMap = dataRaw is Map<String, dynamic>
        ? dataRaw
        : <String, dynamic>{};

    return parseAssessmentTreeWithDrafts(formulirMap);
  }

  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async {
    final Response<dynamic> response = await _client.get(
      '/public/penilaian-selesai/$activityId/opd/$opdId',
    );
    final Map<String, dynamic> formulirMap = extractMapData(response.data);

    return parseAssessmentTreeWithDrafts(formulirMap);
  }
}

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  final Dio client = ref.watch(dioProvider);
  return AssessmentRepository(client);
});
