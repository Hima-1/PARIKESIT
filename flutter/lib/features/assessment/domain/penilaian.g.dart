// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penilaian.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Penilaian _$PenilaianFromJson(Map<String, dynamic> json) => _Penilaian(
  id: (json['id'] as num).toInt(),
  formulirId: (json['formulir_id'] as num).toInt(),
  indikatorId: (json['indikator_id'] as num).toInt(),
  nilai: const FlexibleDoubleConverter().fromJson(json['nilai']),
  catatan: json['catatan'] as String? ?? null,
  evaluasi: json['evaluasi'] as String? ?? null,
  buktiDukung: json['bukti_dukung'] == null
      ? null
      : _buktiDukungFromJson(json['bukti_dukung']),
  catatanKoreksi: json['catatan_koreksi'] as String? ?? null,
  dikerjakanBy: (json['dikerjakan_by'] as num?)?.toInt() ?? null,
  diupdateBy: (json['diupdate_by'] as num?)?.toInt() ?? null,
  dikoreksiBy: (json['dikoreksi_by'] as num?)?.toInt() ?? null,
  nilaiDiupdate: json['nilai_diupdate'] == null
      ? null
      : const NullableFlexibleDoubleConverter().fromJson(
          json['nilai_diupdate'],
        ),
  nilaiKoreksi: json['nilai_koreksi'] == null
      ? null
      : const NullableFlexibleDoubleConverter().fromJson(json['nilai_koreksi']),
  status: $enumDecodeNullable(_$PenilaianStatusEnumMap, json['status']) ?? null,
  tanggalDiperbarui: json['tanggal_diperbarui'] == null
      ? null
      : const NullableLaravelDateConverter().fromJson(
          json['tanggal_diperbarui'] as String?,
        ),
  tanggalDikoreksi: json['tanggal_dikoreksi'] == null
      ? null
      : const NullableLaravelDateConverter().fromJson(
          json['tanggal_dikoreksi'] as String?,
        ),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$PenilaianToJson(_Penilaian instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formulir_id': instance.formulirId,
      'indikator_id': instance.indikatorId,
      'nilai': const FlexibleDoubleConverter().toJson(instance.nilai),
      'catatan': instance.catatan,
      'evaluasi': instance.evaluasi,
      'bukti_dukung': _buktiDukungToJson(instance.buktiDukung),
      'catatan_koreksi': instance.catatanKoreksi,
      'dikerjakan_by': instance.dikerjakanBy,
      'diupdate_by': instance.diupdateBy,
      'dikoreksi_by': instance.dikoreksiBy,
      'nilai_diupdate': const NullableFlexibleDoubleConverter().toJson(
        instance.nilaiDiupdate,
      ),
      'nilai_koreksi': const NullableFlexibleDoubleConverter().toJson(
        instance.nilaiKoreksi,
      ),
      'status': _$PenilaianStatusEnumMap[instance.status],
      'tanggal_diperbarui': const NullableLaravelDateConverter().toJson(
        instance.tanggalDiperbarui,
      ),
      'tanggal_dikoreksi': const NullableLaravelDateConverter().toJson(
        instance.tanggalDikoreksi,
      ),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$PenilaianStatusEnumMap = {
  PenilaianStatus.draft: 'draft',
  PenilaianStatus.sent: 'sent',
  PenilaianStatus.approved: 'approved',
  PenilaianStatus.rejected: 'rejected',
  PenilaianStatus.returned: 'returned',
};
