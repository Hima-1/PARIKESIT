// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_dokumentasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileDokumentasi _$FileDokumentasiFromJson(Map<String, dynamic> json) =>
    _FileDokumentasi(
      id: const FlexibleStringConverter().fromJson(json['id']),
      dokumentasiKegiatanId: const FlexibleStringConverter().fromJson(
        json['dokumentasi_kegiatan_id'],
      ),
      namaFile: json['nama_file'] as String,
      tipeFile: json['tipe_file'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FileDokumentasiToJson(_FileDokumentasi instance) =>
    <String, dynamic>{
      'id': const FlexibleStringConverter().toJson(instance.id),
      'dokumentasi_kegiatan_id': const FlexibleStringConverter().toJson(
        instance.dokumentasiKegiatanId,
      ),
      'nama_file': instance.namaFile,
      'tipe_file': instance.tipeFile,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
