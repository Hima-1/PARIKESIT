import 'package:freezed_annotation/freezed_annotation.dart';

part 'bukti_dukung.freezed.dart';
part 'bukti_dukung.g.dart';

@freezed
abstract class BuktiDukung with _$BuktiDukung {
  const factory BuktiDukung({
    required int id,
    @JsonKey(name: 'penilaian_id') required int penilaianId,
    required String path,
    @JsonKey(name: 'nama_file') required String namaFile,
    @JsonKey(name: 'ukuran_file') required int ukuranFile,
    @JsonKey(name: 'created_at') @Default(null) DateTime? createdAt,
    @JsonKey(name: 'updated_at') @Default(null) DateTime? updatedAt,
  }) = _BuktiDukung;

  factory BuktiDukung.fromJson(Map<String, dynamic> json) =>
      _$BuktiDukungFromJson(json);
}
