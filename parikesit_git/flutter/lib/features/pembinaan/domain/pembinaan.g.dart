// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pembinaan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pembinaan _$PembinaanFromJson(Map<String, dynamic> json) => _Pembinaan(
  id: const FlexibleStringConverter().fromJson(json['id']),
  createdById: const FlexibleStringConverter().fromJson(json['created_by_id']),
  directoryPembinaan: json['directory_pembinaan'] as String,
  judulPembinaan: json['judul_pembinaan'] as String,
  buktiDukungUndanganPembinaan:
      json['bukti_dukung_undangan_pembinaan'] as String,
  daftarHadirPembinaan: json['daftar_hadir_pembinaan'] as String,
  materiPembinaan: json['materi_pembinaan'] as String,
  notulaPembinaan: json['notula_pembinaan'] as String,
  creatorName: json['creator_name'] as String? ?? 'Pengguna',
  files:
      (json['file_pembinaan'] as List<dynamic>?)
          ?.map((e) => FilePembinaan.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PembinaanToJson(
  _Pembinaan instance,
) => <String, dynamic>{
  'id': const FlexibleStringConverter().toJson(instance.id),
  'created_by_id': const FlexibleStringConverter().toJson(instance.createdById),
  'directory_pembinaan': instance.directoryPembinaan,
  'judul_pembinaan': instance.judulPembinaan,
  'bukti_dukung_undangan_pembinaan': instance.buktiDukungUndanganPembinaan,
  'daftar_hadir_pembinaan': instance.daftarHadirPembinaan,
  'materi_pembinaan': instance.materiPembinaan,
  'notula_pembinaan': instance.notulaPembinaan,
  'creator_name': instance.creatorName,
  'file_pembinaan': instance.files,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
