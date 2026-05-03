// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_assessment_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminAssessmentProgress _$AdminAssessmentProgressFromJson(
  Map<String, dynamic> json,
) => _AdminAssessmentProgress(
  id: (json['id'] as num).toInt(),
  name: json['nama'] as String,
  date: DateTime.parse(json['tanggal'] as String),
  opdFilledCount: (json['opd_filled_count'] as num).toInt(),
  opdTotalCount: (json['opd_total_count'] as num).toInt(),
  walidataCorrectedCount: (json['walidata_corrected_count'] as num).toInt(),
  walidataTotalCount: (json['walidata_total_count'] as num).toInt(),
);

Map<String, dynamic> _$AdminAssessmentProgressToJson(
  _AdminAssessmentProgress instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.name,
  'tanggal': instance.date.toIso8601String(),
  'opd_filled_count': instance.opdFilledCount,
  'opd_total_count': instance.opdTotalCount,
  'walidata_corrected_count': instance.walidataCorrectedCount,
  'walidata_total_count': instance.walidataTotalCount,
};
