// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walidata_dashboard_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalidataDashboardProgress _$WalidataDashboardProgressFromJson(
  Map<String, dynamic> json,
) => _WalidataDashboardProgress(
  id: (json['id'] as num).toInt(),
  name: json['nama'] as String,
  date: DateTime.parse(json['tanggal'] as String),
  finalCorrectionScore: (json['nilai_koreksi_akhir'] as num?)?.toDouble(),
  uncorrectedIndicators: (json['indikator_belum_dikoreksi'] as List<dynamic>)
      .map((e) => UncorrectedIndicator.fromJson(e as Map<String, dynamic>))
      .toList(),
  stats: WalidataStats.fromJson(
    json['statistik_walidata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WalidataDashboardProgressToJson(
  _WalidataDashboardProgress instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.name,
  'tanggal': instance.date.toIso8601String(),
  'nilai_koreksi_akhir': instance.finalCorrectionScore,
  'indikator_belum_dikoreksi': instance.uncorrectedIndicators,
  'statistik_walidata': instance.stats,
};

_UncorrectedIndicator _$UncorrectedIndicatorFromJson(
  Map<String, dynamic> json,
) => _UncorrectedIndicator(
  id: (json['id'] as num).toInt(),
  name: json['nama'] as String,
  domain: json['domain'] as String,
  aspect: json['aspek'] as String,
  userId: (json['user_id'] as num).toInt(),
  userName: json['user_name'] as String,
);

Map<String, dynamic> _$UncorrectedIndicatorToJson(
  _UncorrectedIndicator instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.name,
  'domain': instance.domain,
  'aspek': instance.aspect,
  'user_id': instance.userId,
  'user_name': instance.userName,
};

_WalidataStats _$WalidataStatsFromJson(Map<String, dynamic> json) =>
    _WalidataStats(
      totalIndicators: (json['total_indikator'] as num).toInt(),
      correctedCount: (json['terkoreksi'] as num).toInt(),
      percentage: (json['persentase'] as num).toDouble(),
    );

Map<String, dynamic> _$WalidataStatsToJson(_WalidataStats instance) =>
    <String, dynamic>{
      'total_indikator': instance.totalIndicators,
      'terkoreksi': instance.correctedCount,
      'persentase': instance.percentage,
    };
