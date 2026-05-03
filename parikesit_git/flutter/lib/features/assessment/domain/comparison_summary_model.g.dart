// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparison_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComparisonSummaryModel _$ComparisonSummaryModelFromJson(
  Map<String, dynamic> json,
) => _ComparisonSummaryModel(
  opdId: (json['opd_id'] as num).toInt(),
  opdName: json['nama_opd'] as String,
  skorMandiri: (json['skor_mandiri'] as num).toDouble(),
  skorWalidata: (json['skor_walidata'] as num).toDouble(),
  skorBps: (json['skor_bps'] as num).toDouble(),
);

Map<String, dynamic> _$ComparisonSummaryModelToJson(
  _ComparisonSummaryModel instance,
) => <String, dynamic>{
  'opd_id': instance.opdId,
  'nama_opd': instance.opdName,
  'skor_mandiri': instance.skorMandiri,
  'skor_walidata': instance.skorWalidata,
  'skor_bps': instance.skorBps,
};
