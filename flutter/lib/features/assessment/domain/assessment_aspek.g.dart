// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_aspek.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssessmentAspek _$AssessmentAspekFromJson(Map<String, dynamic> json) =>
    _AssessmentAspek(
      id: (json['id'] as num).toInt(),
      domainId: (json['domain_id'] as num).toInt(),
      namaAspek: json['nama_aspek'] as String,
      bobotAspek: (json['bobot_aspek'] as num).toDouble(),
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

Map<String, dynamic> _$AssessmentAspekToJson(_AssessmentAspek instance) =>
    <String, dynamic>{
      'id': instance.id,
      'domain_id': instance.domainId,
      'nama_aspek': instance.namaAspek,
      'bobot_aspek': instance.bobotAspek,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
