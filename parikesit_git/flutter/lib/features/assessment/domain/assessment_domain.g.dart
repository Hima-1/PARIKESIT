// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssessmentDomain _$AssessmentDomainFromJson(Map<String, dynamic> json) =>
    _AssessmentDomain(
      id: (json['id'] as num).toInt(),
      namaDomain: json['nama_domain'] as String,
      bobotDomain: (json['bobot_domain'] as num).toDouble(),
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

Map<String, dynamic> _$AssessmentDomainToJson(_AssessmentDomain instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_domain': instance.namaDomain,
      'bobot_domain': instance.bobotDomain,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
