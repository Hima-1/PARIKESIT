// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_pembinaan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilePembinaan _$FilePembinaanFromJson(Map<String, dynamic> json) =>
    _FilePembinaan(
      id: const FlexibleStringConverter().fromJson(json['id']),
      pembinaanId: const FlexibleStringConverter().fromJson(
        json['pembinaan_id'],
      ),
      namaFile: json['nama_file'] as String,
      tipeFile: json['tipe_file'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FilePembinaanToJson(
  _FilePembinaan instance,
) => <String, dynamic>{
  'id': const FlexibleStringConverter().toJson(instance.id),
  'pembinaan_id': const FlexibleStringConverter().toJson(instance.pembinaanId),
  'nama_file': instance.namaFile,
  'tipe_file': instance.tipeFile,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
