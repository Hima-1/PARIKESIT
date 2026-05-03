import 'package:freezed_annotation/freezed_annotation.dart';

part 'walidata_dashboard_progress.freezed.dart';
part 'walidata_dashboard_progress.g.dart';

@freezed
abstract class WalidataDashboardProgress with _$WalidataDashboardProgress {
  const factory WalidataDashboardProgress({
    required int id,
    @JsonKey(name: 'nama') required String name,
    @JsonKey(name: 'tanggal') required DateTime date,
    @JsonKey(name: 'nilai_koreksi_akhir') double? finalCorrectionScore,
    @JsonKey(name: 'indikator_belum_dikoreksi')
    required List<UncorrectedIndicator> uncorrectedIndicators,
    @JsonKey(name: 'statistik_walidata') required WalidataStats stats,
  }) = _WalidataDashboardProgress;

  factory WalidataDashboardProgress.fromJson(Map<String, dynamic> json) =>
      _$WalidataDashboardProgressFromJson(json);
}

@freezed
abstract class UncorrectedIndicator with _$UncorrectedIndicator {
  const factory UncorrectedIndicator({
    required int id,
    @JsonKey(name: 'nama') required String name,
    @JsonKey(name: 'domain') required String domain,
    @JsonKey(name: 'aspek') required String aspect,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'user_name') required String userName,
  }) = _UncorrectedIndicator;

  factory UncorrectedIndicator.fromJson(Map<String, dynamic> json) =>
      _$UncorrectedIndicatorFromJson(json);
}

@freezed
abstract class WalidataStats with _$WalidataStats {
  const factory WalidataStats({
    @JsonKey(name: 'total_indikator') required int totalIndicators,
    @JsonKey(name: 'terkoreksi') required int correctedCount,
    @JsonKey(name: 'persentase') required double percentage,
  }) = _WalidataStats;

  factory WalidataStats.fromJson(Map<String, dynamic> json) =>
      _$WalidataStatsFromJson(json);
}
