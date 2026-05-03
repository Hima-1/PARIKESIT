// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_indikator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssessmentIndikator _$AssessmentIndikatorFromJson(Map<String, dynamic> json) =>
    _AssessmentIndikator(
      id: (json['id'] as num).toInt(),
      aspekId: (json['aspek_id'] as num).toInt(),
      kodeIndikator: json['kode_indikator'] as String? ?? null,
      namaIndikator: json['nama_indikator'] as String,
      namaDomain: json['nama_domain'] as String? ?? null,
      namaAspek: json['nama_aspek'] as String? ?? null,
      bobotIndikator: const FlexibleDoubleConverter().fromJson(
        json['bobot_indikator'],
      ),
      level1Kriteria: json['level_1_kriteria'] as String? ?? null,
      level2Kriteria: json['level_2_kriteria'] as String? ?? null,
      level3Kriteria: json['level_3_kriteria'] as String? ?? null,
      level4Kriteria: json['level_4_kriteria'] as String? ?? null,
      level5Kriteria: json['level_5_kriteria'] as String? ?? null,
      level1Kriteria10101: json['level_1_kriteria_10101'] as String? ?? null,
      level2Kriteria10101: json['level_2_kriteria_10101'] as String? ?? null,
      level3Kriteria10101: json['level_3_kriteria_10101'] as String? ?? null,
      level4Kriteria10101: json['level_4_kriteria_10101'] as String? ?? null,
      level5Kriteria10101: json['level_5_kriteria_10101'] as String? ?? null,
      level1Kriteria10201: json['level_1_kriteria_10201'] as String? ?? null,
      level2Kriteria10201: json['level_2_kriteria_10201'] as String? ?? null,
      level3Kriteria10201: json['level_3_kriteria_10201'] as String? ?? null,
      level4Kriteria10201: json['level_4_kriteria_10201'] as String? ?? null,
      level5Kriteria10201: json['level_5_kriteria_10201'] as String? ?? null,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$AssessmentIndikatorToJson(
  _AssessmentIndikator instance,
) => <String, dynamic>{
  'id': instance.id,
  'aspek_id': instance.aspekId,
  'kode_indikator': instance.kodeIndikator,
  'nama_indikator': instance.namaIndikator,
  'nama_domain': instance.namaDomain,
  'nama_aspek': instance.namaAspek,
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
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
};
