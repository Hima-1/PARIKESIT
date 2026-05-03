import 'package:freezed_annotation/freezed_annotation.dart';

part 'opd_dashboard_progress.freezed.dart';
part 'opd_dashboard_progress.g.dart';

@freezed
abstract class OpdDashboardProgress with _$OpdDashboardProgress {
  const factory OpdDashboardProgress({
    required int id,
    @JsonKey(name: 'nama') required String name,
    @JsonKey(name: 'tanggal') required DateTime date,
    @JsonKey(name: 'progress_per_indikator')
    required OpdProgressDetail progressPerIndikator,
    @JsonKey(name: 'hasil_penilaian_akhir') double? hasilPenilaianAkhir,
    @JsonKey(name: 'progress_koreksi_walidata')
    required OpdProgressDetail progressKoreksiWalidata,
    @JsonKey(name: 'progress_evaluasi_admin')
    required OpdProgressDetail progressEvaluasiAdmin,
  }) = _OpdDashboardProgress;

  factory OpdDashboardProgress.fromJson(Map<String, dynamic> json) =>
      _$OpdDashboardProgressFromJson(json);
}

@freezed
abstract class OpdProgressDetail with _$OpdProgressDetail {
  const factory OpdProgressDetail({
    required int total,
    @JsonKey(name: 'terisi') int? terisi,
    @JsonKey(name: 'sudah_dikoreksi') int? sudahDikoreksi,
    @JsonKey(name: 'sudah_dievaluasi') int? sudahDievaluasi,
    required double persentase,
  }) = _OpdProgressDetail;

  factory OpdProgressDetail.fromJson(Map<String, dynamic> json) =>
      _$OpdProgressDetailFromJson(json);
}
