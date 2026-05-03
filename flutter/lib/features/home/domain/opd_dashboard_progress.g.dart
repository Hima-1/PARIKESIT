// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opd_dashboard_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpdDashboardProgress _$OpdDashboardProgressFromJson(
  Map<String, dynamic> json,
) => _OpdDashboardProgress(
  id: (json['id'] as num).toInt(),
  name: json['nama'] as String,
  date: DateTime.parse(json['tanggal'] as String),
  progressPerIndikator: OpdProgressDetail.fromJson(
    json['progress_per_indikator'] as Map<String, dynamic>,
  ),
  hasilPenilaianAkhir: (json['hasil_penilaian_akhir'] as num?)?.toDouble(),
  progressKoreksiWalidata: OpdProgressDetail.fromJson(
    json['progress_koreksi_walidata'] as Map<String, dynamic>,
  ),
  progressEvaluasiAdmin: OpdProgressDetail.fromJson(
    json['progress_evaluasi_admin'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OpdDashboardProgressToJson(
  _OpdDashboardProgress instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.name,
  'tanggal': instance.date.toIso8601String(),
  'progress_per_indikator': instance.progressPerIndikator,
  'hasil_penilaian_akhir': instance.hasilPenilaianAkhir,
  'progress_koreksi_walidata': instance.progressKoreksiWalidata,
  'progress_evaluasi_admin': instance.progressEvaluasiAdmin,
};

_OpdProgressDetail _$OpdProgressDetailFromJson(Map<String, dynamic> json) =>
    _OpdProgressDetail(
      total: (json['total'] as num).toInt(),
      terisi: (json['terisi'] as num?)?.toInt(),
      sudahDikoreksi: (json['sudah_dikoreksi'] as num?)?.toInt(),
      sudahDievaluasi: (json['sudah_dievaluasi'] as num?)?.toInt(),
      persentase: (json['persentase'] as num).toDouble(),
    );

Map<String, dynamic> _$OpdProgressDetailToJson(_OpdProgressDetail instance) =>
    <String, dynamic>{
      'total': instance.total,
      'terisi': instance.terisi,
      'sudah_dikoreksi': instance.sudahDikoreksi,
      'sudah_dievaluasi': instance.sudahDievaluasi,
      'persentase': instance.persentase,
    };
