// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opd_performance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpdPerformance _$OpdPerformanceFromJson(Map<String, dynamic> json) =>
    _OpdPerformance(
      opdName: json['opd_name'] as String,
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$OpdPerformanceToJson(_OpdPerformance instance) =>
    <String, dynamic>{'opd_name': instance.opdName, 'score': instance.score};
