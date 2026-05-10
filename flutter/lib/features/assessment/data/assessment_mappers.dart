import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

AssessmentFormModel mapFormulir(Map<String, dynamic> item) {
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

        final List<AspectModel> aspects = aspectsRaw
            .whereType<Map<String, dynamic>>()
            .map((Map<String, dynamic> aspectRaw) {
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
                    opd: parseNullableDouble(p['nilai']),
                    walidata: parseNullableDouble(p['nilai_diupdate']),
                    admin: parseNullableDouble(p['nilai_koreksi']),
                  );
                } else if (penilaianRaw is Map<String, dynamic>) {
                  score = RoleScore(
                    opd: parseNullableDouble(penilaianRaw['nilai']),
                    walidata: parseNullableDouble(
                      penilaianRaw['nilai_diupdate'],
                    ),
                    admin: parseNullableDouble(penilaianRaw['nilai_koreksi']),
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
                      parseNullableDouble(indicatorRaw['bobot_indikator']) ?? 0,
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
            })
            .toList();

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
    opdCount: _parseInt(item['participating_opd_count']),
    scores: _mapRoleScore(item),
    reviewProgress: _mapReviewProgress(item['review_progress']),
  );
}

(AssessmentFormModel, Map<int, Penilaian>) parseAssessmentTreeWithDrafts(
  Map<String, dynamic> formulirMap,
) {
  final AssessmentFormModel model = mapFormulir(formulirMap);
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
        final Map<String, dynamic>? penilaianData = _resolveFilledPenilaianMap(
          penilaianRaw,
          requiredField: 'nilai',
        );

        if (penilaianData != null) {
          final Penilaian penilaian = Penilaian.fromJson(penilaianData);
          assessments[penilaian.indikatorId] = penilaian;
        }
      }
    }
  }

  return (model, assessments);
}

ComparisonSummaryModel mapComparisonSummary(Map<String, dynamic> item) {
  return ComparisonSummaryModel(
    opdId:
        (item['opd_id'] as num?)?.toInt() ?? (item['id'] as num?)?.toInt() ?? 0,
    opdName: item['nama_opd']?.toString() ?? item['name']?.toString() ?? 'OPD',
    skorMandiri:
        parseNullableDouble(item['skor_mandiri'] ?? item['opd_score']) ?? 0,
    skorWalidata:
        parseNullableDouble(item['skor_walidata'] ?? item['walidata_score']) ??
        0,
    skorBps: parseNullableDouble(item['skor_bps'] ?? item['admin_score']) ?? 0,
  );
}

ReviewProgressSummary? _mapReviewProgress(dynamic raw) {
  if (raw is! Map<String, dynamic>) {
    return null;
  }

  final List<PendingIndicatorPreview> pendingIndicatorPreview =
      (raw['pending_indicator_preview'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(PendingIndicatorPreview.fromJson)
          .toList(growable: false);

  return ReviewProgressSummary(
    totalIndicators: _parseInt(raw['total_indicators']),
    correctedCount: _parseInt(raw['corrected_count']),
    percentage: parseNullableDouble(raw['percentage']) ?? 0,
    finalCorrectionScore: parseNullableDouble(raw['final_correction_score']),
    pendingIndicatorPreview: pendingIndicatorPreview,
  );
}

RoleScore? _mapRoleScore(Map<String, dynamic> json) {
  final dynamic scoresRaw =
      json['scores'] ?? json['comparison'] ?? json['penilaian'];
  if (scoresRaw is Map<String, dynamic>) {
    return RoleScore(
      opd: parseNullableDouble(
        scoresRaw['opd'] ?? scoresRaw['opd_score'] ?? scoresRaw['nilai'],
      ),
      walidata: parseNullableDouble(
        scoresRaw['walidata'] ??
            scoresRaw['walidata_score'] ??
            scoresRaw['nilai_diupdate'],
      ),
      admin: parseNullableDouble(
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
        opd: parseNullableDouble(p['nilai']),
        walidata: parseNullableDouble(p['nilai_diupdate']),
        admin: parseNullableDouble(p['nilai_koreksi']),
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

bool _isFieldFilled(Map<String, dynamic> json, String field) {
  final dynamic value = json[field];

  if (field == 'evaluasi' || field == 'catatan' || field == 'catatan_koreksi') {
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
