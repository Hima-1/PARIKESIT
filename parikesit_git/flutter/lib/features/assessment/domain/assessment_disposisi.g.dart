// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_disposisi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssessmentDisposisi _$AssessmentDisposisiFromJson(Map<String, dynamic> json) =>
    _AssessmentDisposisi(
      id: (json['id'] as num).toInt(),
      formulirId: (json['formulir_id'] as num).toInt(),
      indikatorId: (json['indikator_id'] as num?)?.toInt(),
      fromUserId: (json['from_profile_id'] as num?)?.toInt(),
      toUserId: (json['to_profile_id'] as num?)?.toInt(),
      assignedUserId: (json['assigned_profile_id'] as num?)?.toInt(),
      status: $enumDecode(_$DisposisiStatusEnumMap, json['status']),
      catatan: json['catatan'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AssessmentDisposisiToJson(
  _AssessmentDisposisi instance,
) => <String, dynamic>{
  'id': instance.id,
  'formulir_id': instance.formulirId,
  'indikator_id': instance.indikatorId,
  'from_profile_id': instance.fromUserId,
  'to_profile_id': instance.toUserId,
  'assigned_profile_id': instance.assignedUserId,
  'status': _$DisposisiStatusEnumMap[instance.status]!,
  'catatan': instance.catatan,
  'is_completed': instance.isCompleted,
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$DisposisiStatusEnumMap = {
  DisposisiStatus.sent: 'sent',
  DisposisiStatus.returned: 'returned',
  DisposisiStatus.approved: 'approved',
  DisposisiStatus.rejected: 'rejected',
};
