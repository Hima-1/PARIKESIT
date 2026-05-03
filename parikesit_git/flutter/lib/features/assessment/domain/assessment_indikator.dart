import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_converters.dart';

part 'assessment_indikator.freezed.dart';
part 'assessment_indikator.g.dart';

@freezed
abstract class AssessmentIndikator with _$AssessmentIndikator {
  const AssessmentIndikator._();

  const factory AssessmentIndikator({
    required int id,
    @JsonKey(name: 'aspek_id') required int aspekId,
    @JsonKey(name: 'kode_indikator') @Default(null) String? kodeIndikator,
    @JsonKey(name: 'nama_indikator') required String namaIndikator,
    @JsonKey(name: 'nama_domain') @Default(null) String? namaDomain,
    @JsonKey(name: 'nama_aspek') @Default(null) String? namaAspek,
    @JsonKey(name: 'bobot_indikator')
    @FlexibleDoubleConverter()
    required double bobotIndikator,
    @JsonKey(name: 'level_1_kriteria') @Default(null) String? level1Kriteria,
    @JsonKey(name: 'level_2_kriteria') @Default(null) String? level2Kriteria,
    @JsonKey(name: 'level_3_kriteria') @Default(null) String? level3Kriteria,
    @JsonKey(name: 'level_4_kriteria') @Default(null) String? level4Kriteria,
    @JsonKey(name: 'level_5_kriteria') @Default(null) String? level5Kriteria,
    @JsonKey(name: 'level_1_kriteria_10101')
    @Default(null)
    String? level1Kriteria10101,
    @JsonKey(name: 'level_2_kriteria_10101')
    @Default(null)
    String? level2Kriteria10101,
    @JsonKey(name: 'level_3_kriteria_10101')
    @Default(null)
    String? level3Kriteria10101,
    @JsonKey(name: 'level_4_kriteria_10101')
    @Default(null)
    String? level4Kriteria10101,
    @JsonKey(name: 'level_5_kriteria_10101')
    @Default(null)
    String? level5Kriteria10101,
    @JsonKey(name: 'level_1_kriteria_10201')
    @Default(null)
    String? level1Kriteria10201,
    @JsonKey(name: 'level_2_kriteria_10201')
    @Default(null)
    String? level2Kriteria10201,
    @JsonKey(name: 'level_3_kriteria_10201')
    @Default(null)
    String? level3Kriteria10201,
    @JsonKey(name: 'level_4_kriteria_10201')
    @Default(null)
    String? level4Kriteria10201,
    @JsonKey(name: 'level_5_kriteria_10201')
    @Default(null)
    String? level5Kriteria10201,
    @JsonKey(name: 'created_at') @Default(null) DateTime? createdAt,
    @JsonKey(name: 'updated_at') @Default(null) DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') @Default(null) DateTime? deletedAt,
  }) = _AssessmentIndikator;

  factory AssessmentIndikator.fromJson(Map<String, dynamic> json) =>
      _$AssessmentIndikatorFromJson(json);

  String? effectiveLevelKriteria(int level, {String? indicatorCode}) {
    final normalizedCode = (indicatorCode ?? kodeIndikator ?? '').trim();

    if (normalizedCode == '10101') {
      final override = _kriteriaByCodeAndLevel10101(level);
      if (override != null && override.isNotEmpty) {
        return override;
      }
    }

    if (normalizedCode == '10201') {
      final override = _kriteriaByCodeAndLevel10201(level);
      if (override != null && override.isNotEmpty) {
        return override;
      }
    }

    return _baseKriteriaByLevel(level);
  }

  String? _baseKriteriaByLevel(int level) {
    switch (level) {
      case 1:
        return level1Kriteria;
      case 2:
        return level2Kriteria;
      case 3:
        return level3Kriteria;
      case 4:
        return level4Kriteria;
      case 5:
        return level5Kriteria;
      default:
        return null;
    }
  }

  String? _kriteriaByCodeAndLevel10101(int level) {
    switch (level) {
      case 1:
        return level1Kriteria10101;
      case 2:
        return level2Kriteria10101;
      case 3:
        return level3Kriteria10101;
      case 4:
        return level4Kriteria10101;
      case 5:
        return level5Kriteria10101;
      default:
        return null;
    }
  }

  String? _kriteriaByCodeAndLevel10201(int level) {
    switch (level) {
      case 1:
        return level1Kriteria10201;
      case 2:
        return level2Kriteria10201;
      case 3:
        return level3Kriteria10201;
      case 4:
        return level4Kriteria10201;
      case 5:
        return level5Kriteria10201;
      default:
        return null;
    }
  }
}
