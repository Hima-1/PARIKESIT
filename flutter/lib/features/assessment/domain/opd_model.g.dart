// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opd_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpdProgress _$OpdProgressFromJson(Map<String, dynamic> json) => _OpdProgress(
  count: (json['count'] as num?)?.toInt() ?? 0,
  percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$OpdProgressToJson(_OpdProgress instance) =>
    <String, dynamic>{
      'count': instance.count,
      'percentage': instance.percentage,
    };

_OpdModel _$OpdModelFromJson(Map<String, dynamic> json) => _OpdModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String?,
  role: json['role'] as String?,
  nomorTelepon: json['nomor_telepon'] as String?,
  opdScore: (json['opd_score'] as num?)?.toDouble(),
  walidataScore: (json['walidata_score'] as num?)?.toDouble(),
  adminScore: (json['admin_score'] as num?)?.toDouble(),
  totalIndicators: (json['total_indikator'] as num?)?.toInt() ?? 0,
  opdProgress: json['opd_progress'] == null
      ? null
      : OpdProgress.fromJson(json['opd_progress'] as Map<String, dynamic>),
  walidataProgress: json['walidata_progress'] == null
      ? null
      : OpdProgress.fromJson(json['walidata_progress'] as Map<String, dynamic>),
  adminProgress: json['admin_progress'] == null
      ? null
      : OpdProgress.fromJson(json['admin_progress'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OpdModelToJson(_OpdModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'nomor_telepon': instance.nomorTelepon,
  'opd_score': instance.opdScore,
  'walidata_score': instance.walidataScore,
  'admin_score': instance.adminScore,
  'total_indikator': instance.totalIndicators,
  'opd_progress': instance.opdProgress,
  'walidata_progress': instance.walidataProgress,
  'admin_progress': instance.adminProgress,
};
