// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dokumentasi_kegiatan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DokumentasiKegiatan _$DokumentasiKegiatanFromJson(Map<String, dynamic> json) =>
    _DokumentasiKegiatan(
      id: const FlexibleStringConverter().fromJson(json['id']),
      createdById: const FlexibleStringConverter().fromJson(
        json['created_by_id'],
      ),
      directoryDokumentasi: json['directory_dokumentasi'] as String,
      judulDokumentasi: json['judul_dokumentasi'] as String,
      buktiDukungUndanganDokumentasi:
          json['bukti_dukung_undangan_dokumentasi'] as String,
      daftarHadirDokumentasi: json['daftar_hadir_dokumentasi'] as String,
      materiDokumentasi: json['materi_dokumentasi'] as String,
      notulaDokumentasi: json['notula_dokumentasi'] as String,
      creatorName: json['creator_name'] as String? ?? 'Pengguna',
      files:
          (json['file_dokumentasi'] as List<dynamic>?)
              ?.map((e) => FileDokumentasi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DokumentasiKegiatanToJson(
  _DokumentasiKegiatan instance,
) => <String, dynamic>{
  'id': const FlexibleStringConverter().toJson(instance.id),
  'created_by_id': const FlexibleStringConverter().toJson(instance.createdById),
  'directory_dokumentasi': instance.directoryDokumentasi,
  'judul_dokumentasi': instance.judulDokumentasi,
  'bukti_dukung_undangan_dokumentasi': instance.buktiDukungUndanganDokumentasi,
  'daftar_hadir_dokumentasi': instance.daftarHadirDokumentasi,
  'materi_dokumentasi': instance.materiDokumentasi,
  'notula_dokumentasi': instance.notulaDokumentasi,
  'creator_name': instance.creatorName,
  'file_dokumentasi': instance.files,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
