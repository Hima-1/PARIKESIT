import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:parikesit/core/utils/json_converters.dart';

part 'penilaian.freezed.dart';
part 'penilaian.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PenilaianStatus { draft, sent, approved, rejected, returned }

List<String>? _buktiDukungFromJson(Object? json) =>
    const NullableEvidenceListConverter().fromJson(json);

Object? _buktiDukungToJson(List<String>? value) =>
    const NullableEvidenceListConverter().toJson(value);

@freezed
abstract class Penilaian with _$Penilaian {
  const factory Penilaian({
    required int id,
    @JsonKey(name: 'formulir_id') required int formulirId,
    @JsonKey(name: 'indikator_id') required int indikatorId,
    @FlexibleDoubleConverter() required double nilai,
    @Default(null) String? catatan,
    @Default(null) String? evaluasi,
    @JsonKey(
      name: 'bukti_dukung',
      fromJson: _buktiDukungFromJson,
      toJson: _buktiDukungToJson,
    )
    @Default(null)
    List<String>? buktiDukung,
    @JsonKey(name: 'catatan_koreksi') @Default(null) String? catatanKoreksi,
    @JsonKey(name: 'dikerjakan_by') @Default(null) int? dikerjakanBy,
    @JsonKey(name: 'diupdate_by') @Default(null) int? diupdateBy,
    @JsonKey(name: 'dikoreksi_by') @Default(null) int? dikoreksiBy,
    @JsonKey(name: 'nilai_diupdate')
    @Default(null)
    @NullableFlexibleDoubleConverter()
    double? nilaiDiupdate,
    @JsonKey(name: 'nilai_koreksi')
    @Default(null)
    @NullableFlexibleDoubleConverter()
    double? nilaiKoreksi,
    @Default(null) PenilaianStatus? status,
    @JsonKey(name: 'tanggal_diperbarui')
    @Default(null)
    @NullableLaravelDateConverter()
    DateTime? tanggalDiperbarui,
    @JsonKey(name: 'tanggal_dikoreksi')
    @Default(null)
    @NullableLaravelDateConverter()
    DateTime? tanggalDikoreksi,
    @JsonKey(name: 'created_at') @Default(null) DateTime? createdAt,
    @JsonKey(name: 'updated_at') @Default(null) DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') @Default(null) DateTime? deletedAt,
  }) = _Penilaian;

  factory Penilaian.fromJson(Map<String, dynamic> json) =>
      _$PenilaianFromJson(json);
}
