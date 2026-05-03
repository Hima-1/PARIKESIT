import 'package:freezed_annotation/freezed_annotation.dart';

part 'opd_model.freezed.dart';
part 'opd_model.g.dart';

@freezed
abstract class OpdProgress with _$OpdProgress {
  const factory OpdProgress({
    @Default(0) int count,
    @Default(0) double percentage,
  }) = _OpdProgress;

  factory OpdProgress.fromJson(Map<String, dynamic> json) =>
      _$OpdProgressFromJson(json);
}

@freezed
abstract class OpdModel with _$OpdModel {
  const factory OpdModel({
    required int id,
    required String name,
    String? role,
    @JsonKey(name: 'nomor_telepon') String? nomorTelepon,
    @JsonKey(name: 'opd_score') double? opdScore,
    @JsonKey(name: 'walidata_score') double? walidataScore,
    @JsonKey(name: 'admin_score') double? adminScore,
    @JsonKey(name: 'total_indikator') @Default(0) int totalIndicators,
    @JsonKey(name: 'opd_progress') OpdProgress? opdProgress,
    @JsonKey(name: 'walidata_progress') OpdProgress? walidataProgress,
    @JsonKey(name: 'admin_progress') OpdProgress? adminProgress,
  }) = _OpdModel;

  factory OpdModel.fromJson(Map<String, dynamic> json) =>
      _$OpdModelFromJson(_normalizeOpdJson(json));
}

Map<String, dynamic> _normalizeOpdJson(Map<String, dynamic> json) {
  final Map<String, dynamic> stats = json['stats'] is Map<String, dynamic>
      ? json['stats'] as Map<String, dynamic>
      : const <String, dynamic>{};

  return <String, dynamic>{
    ...json,
    'opd_score': json['opd_score'] ?? stats['opd_score'],
    'walidata_score': json['walidata_score'] ?? stats['walidata_score'],
    'admin_score': json['admin_score'] ?? stats['admin_score'],
    'total_indikator': json['total_indikator'] ?? stats['total_indikator'],
    'opd_progress': json['opd_progress'] ?? stats['opd_progress'],
    'walidata_progress':
        json['walidata_progress'] ?? stats['walidata_progress'],
    'admin_progress': json['admin_progress'] ?? stats['admin_progress'],
  };
}
