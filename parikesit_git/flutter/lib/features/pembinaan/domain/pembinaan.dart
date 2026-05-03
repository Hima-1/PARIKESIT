import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_converters.dart';
import 'file_pembinaan.dart';

part 'pembinaan.freezed.dart';
part 'pembinaan.g.dart';

@freezed
abstract class Pembinaan with _$Pembinaan {
  const factory Pembinaan({
    @FlexibleStringConverter() required String id,
    @FlexibleStringConverter()
    @JsonKey(name: 'created_by_id')
    required String createdById,
    required String directoryPembinaan,
    required String judulPembinaan,
    required String buktiDukungUndanganPembinaan,
    required String daftarHadirPembinaan,
    required String materiPembinaan,
    required String notulaPembinaan,
    @JsonKey(name: 'creator_name') @Default('Pengguna') String creatorName,
    @JsonKey(name: 'file_pembinaan') @Default([]) List<FilePembinaan> files,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Pembinaan;

  factory Pembinaan.fromJson(Map<String, dynamic> json) =>
      _$PembinaanFromJson(json);
}
