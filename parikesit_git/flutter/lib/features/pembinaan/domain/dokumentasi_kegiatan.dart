import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_converters.dart';
import 'file_dokumentasi.dart';

part 'dokumentasi_kegiatan.freezed.dart';
part 'dokumentasi_kegiatan.g.dart';

@freezed
abstract class DokumentasiKegiatan with _$DokumentasiKegiatan {
  const factory DokumentasiKegiatan({
    @FlexibleStringConverter() required String id,
    @FlexibleStringConverter()
    @JsonKey(name: 'created_by_id')
    required String createdById,
    @JsonKey(name: 'directory_dokumentasi')
    required String directoryDokumentasi,
    @JsonKey(name: 'judul_dokumentasi') required String judulDokumentasi,
    @JsonKey(name: 'bukti_dukung_undangan_dokumentasi')
    required String buktiDukungUndanganDokumentasi,
    @JsonKey(name: 'daftar_hadir_dokumentasi')
    required String daftarHadirDokumentasi,
    @JsonKey(name: 'materi_dokumentasi') required String materiDokumentasi,
    @JsonKey(name: 'notula_dokumentasi') required String notulaDokumentasi,
    @JsonKey(name: 'creator_name') @Default('Pengguna') String creatorName,
    @JsonKey(name: 'file_dokumentasi') @Default([]) List<FileDokumentasi> files,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DokumentasiKegiatan;

  factory DokumentasiKegiatan.fromJson(Map<String, dynamic> json) =>
      _$DokumentasiKegiatanFromJson(json);
}
