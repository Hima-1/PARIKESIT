// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleScore _$RoleScoreFromJson(Map<String, dynamic> json) => _RoleScore(
  opd: (json['opd'] as num?)?.toDouble(),
  walidata: (json['walidata'] as num?)?.toDouble(),
  admin: (json['admin'] as num?)?.toDouble(),
);

Map<String, dynamic> _$RoleScoreToJson(_RoleScore instance) =>
    <String, dynamic>{
      'opd': instance.opd,
      'walidata': instance.walidata,
      'admin': instance.admin,
    };

_PendingIndicatorPreview _$PendingIndicatorPreviewFromJson(
  Map<String, dynamic> json,
) => _PendingIndicatorPreview(
  id: (json['id'] as num).toInt(),
  name: json['nama'] as String,
  domain: json['domain'] as String,
  aspect: json['aspek'] as String,
  userId: (json['user_id'] as num).toInt(),
  userName: json['user_name'] as String,
);

Map<String, dynamic> _$PendingIndicatorPreviewToJson(
  _PendingIndicatorPreview instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.name,
  'domain': instance.domain,
  'aspek': instance.aspect,
  'user_id': instance.userId,
  'user_name': instance.userName,
};

_ReviewProgressSummary _$ReviewProgressSummaryFromJson(
  Map<String, dynamic> json,
) => _ReviewProgressSummary(
  totalIndicators: (json['total_indicators'] as num).toInt(),
  correctedCount: (json['corrected_count'] as num).toInt(),
  percentage: json['percentage'] == null
      ? 0
      : const FlexibleDoubleConverter().fromJson(json['percentage']),
  finalCorrectionScore: (json['final_correction_score'] as num?)?.toDouble(),
  pendingIndicatorPreview:
      (json['pending_indicator_preview'] as List<dynamic>?)
          ?.map(
            (e) => PendingIndicatorPreview.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <PendingIndicatorPreview>[],
);

Map<String, dynamic> _$ReviewProgressSummaryToJson(
  _ReviewProgressSummary instance,
) => <String, dynamic>{
  'total_indicators': instance.totalIndicators,
  'corrected_count': instance.correctedCount,
  'percentage': const FlexibleDoubleConverter().toJson(instance.percentage),
  'final_correction_score': instance.finalCorrectionScore,
  'pending_indicator_preview': instance.pendingIndicatorPreview,
};

_AspectModel _$AspectModelFromJson(Map<String, dynamic> json) => _AspectModel(
  id: json['id'] as String,
  name: json['nama_aspek'] as String,
  indicators:
      (json['indikator'] as List<dynamic>?)
          ?.map((e) => IndicatorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <IndicatorModel>[],
  scores: json['scores'] == null
      ? null
      : RoleScore.fromJson(json['scores'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AspectModelToJson(_AspectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_aspek': instance.name,
      'indikator': instance.indicators,
      'scores': instance.scores,
    };

_DomainModel _$DomainModelFromJson(Map<String, dynamic> json) => _DomainModel(
  id: json['id'] as String,
  name: json['nama_domain'] as String,
  date: DateTime.parse(json['updated_at'] as String),
  aspects: (json['aspek'] as List<dynamic>)
      .map((e) => AspectModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  indicatorCount: (json['indicator_count'] as num).toInt(),
  scores: json['scores'] == null
      ? null
      : RoleScore.fromJson(json['scores'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DomainModelToJson(_DomainModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_domain': instance.name,
      'updated_at': instance.date.toIso8601String(),
      'aspek': instance.aspects,
      'indicator_count': instance.indicatorCount,
      'scores': instance.scores,
    };

_AssessmentFormModel _$AssessmentFormModelFromJson(Map<String, dynamic> json) =>
    _AssessmentFormModel(
      id: json['id'] as String,
      title: json['nama_formulir'] as String,
      date: DateTime.parse(json['created_at'] as String),
      domains: (json['domains'] as List<dynamic>)
          .map((e) => DomainModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      opdCount: (json['participating_opd_count'] as num?)?.toInt() ?? 0,
      scores: json['scores'] == null
          ? null
          : RoleScore.fromJson(json['scores'] as Map<String, dynamic>),
      reviewProgress: json['review_progress'] == null
          ? null
          : ReviewProgressSummary.fromJson(
              json['review_progress'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AssessmentFormModelToJson(
  _AssessmentFormModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama_formulir': instance.title,
  'created_at': instance.date.toIso8601String(),
  'domains': instance.domains,
  'participating_opd_count': instance.opdCount,
  'scores': instance.scores,
  'review_progress': instance.reviewProgress,
};

_IndicatorModel _$IndicatorModelFromJson(Map<String, dynamic> json) =>
    _IndicatorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      kodeIndikator: json['kode_indikator'] as String?,
      bobotIndikator: json['bobot_indikator'] == null
          ? 0
          : const FlexibleDoubleConverter().fromJson(json['bobot_indikator']),
      level1Kriteria: json['level_1_kriteria'] as String?,
      level2Kriteria: json['level_2_kriteria'] as String?,
      level3Kriteria: json['level_3_kriteria'] as String?,
      level4Kriteria: json['level_4_kriteria'] as String?,
      level5Kriteria: json['level_5_kriteria'] as String?,
      level1Kriteria10101: json['level_1_kriteria_10101'] as String?,
      level2Kriteria10101: json['level_2_kriteria_10101'] as String?,
      level3Kriteria10101: json['level_3_kriteria_10101'] as String?,
      level4Kriteria10101: json['level_4_kriteria_10101'] as String?,
      level5Kriteria10101: json['level_5_kriteria_10101'] as String?,
      level1Kriteria10201: json['level_1_kriteria_10201'] as String?,
      level2Kriteria10201: json['level_2_kriteria_10201'] as String?,
      level3Kriteria10201: json['level_3_kriteria_10201'] as String?,
      level4Kriteria10201: json['level_4_kriteria_10201'] as String?,
      level5Kriteria10201: json['level_5_kriteria_10201'] as String?,
      scores: json['scores'] == null
          ? null
          : RoleScore.fromJson(json['scores'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IndicatorModelToJson(_IndicatorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kode_indikator': instance.kodeIndikator,
      'bobot_indikator': const FlexibleDoubleConverter().toJson(
        instance.bobotIndikator,
      ),
      'level_1_kriteria': instance.level1Kriteria,
      'level_2_kriteria': instance.level2Kriteria,
      'level_3_kriteria': instance.level3Kriteria,
      'level_4_kriteria': instance.level4Kriteria,
      'level_5_kriteria': instance.level5Kriteria,
      'level_1_kriteria_10101': instance.level1Kriteria10101,
      'level_2_kriteria_10101': instance.level2Kriteria10101,
      'level_3_kriteria_10101': instance.level3Kriteria10101,
      'level_4_kriteria_10101': instance.level4Kriteria10101,
      'level_5_kriteria_10101': instance.level5Kriteria10101,
      'level_1_kriteria_10201': instance.level1Kriteria10201,
      'level_2_kriteria_10201': instance.level2Kriteria10201,
      'level_3_kriteria_10201': instance.level3Kriteria10201,
      'level_4_kriteria_10201': instance.level4Kriteria10201,
      'level_5_kriteria_10201': instance.level5Kriteria10201,
      'scores': instance.scores,
    };
