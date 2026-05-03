// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bukti_dukung.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BuktiDukung _$BuktiDukungFromJson(Map<String, dynamic> json) => _BuktiDukung(
  id: (json['id'] as num).toInt(),
  penilaianId: (json['penilaian_id'] as num).toInt(),
  path: json['path'] as String,
  namaFile: json['nama_file'] as String,
  ukuranFile: (json['ukuran_file'] as num).toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$BuktiDukungToJson(_BuktiDukung instance) =>
    <String, dynamic>{
      'id': instance.id,
      'penilaian_id': instance.penilaianId,
      'path': instance.path,
      'nama_file': instance.namaFile,
      'ukuran_file': instance.ukuranFile,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
