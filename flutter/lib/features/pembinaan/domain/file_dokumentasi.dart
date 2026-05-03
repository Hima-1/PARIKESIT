import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_converters.dart';

part 'file_dokumentasi.freezed.dart';
part 'file_dokumentasi.g.dart';

@freezed
sealed class FileDokumentasi with _$FileDokumentasi {
  const factory FileDokumentasi({
    @FlexibleStringConverter() required String id,
    @FlexibleStringConverter() required String dokumentasiKegiatanId,
    required String namaFile,
    required String tipeFile,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FileDokumentasi;

  factory FileDokumentasi.fromJson(Map<String, dynamic> json) =>
      _$FileDokumentasiFromJson(json);
}
