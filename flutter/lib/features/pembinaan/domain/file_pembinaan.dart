import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_converters.dart';

part 'file_pembinaan.freezed.dart';
part 'file_pembinaan.g.dart';

@freezed
sealed class FilePembinaan with _$FilePembinaan {
  const factory FilePembinaan({
    @FlexibleStringConverter() required String id,
    @FlexibleStringConverter() required String pembinaanId,
    required String namaFile,
    required String tipeFile,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FilePembinaan;

  factory FilePembinaan.fromJson(Map<String, dynamic> json) =>
      _$FilePembinaanFromJson(json);
}
