import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_converters.dart';
import 'assessment_indikator.dart';

part 'assessment_models.freezed.dart';
part 'assessment_models.g.dart';

@freezed
abstract class RoleScore with _$RoleScore {
  const factory RoleScore({double? opd, double? walidata, double? admin}) =
      _RoleScore;

  factory RoleScore.fromJson(Map<String, dynamic> json) =>
      _$RoleScoreFromJson(json);
}

@freezed
abstract class PendingIndicatorPreview with _$PendingIndicatorPreview {
  const factory PendingIndicatorPreview({
    required int id,
    @JsonKey(name: 'nama') required String name,
    required String domain,
    @JsonKey(name: 'aspek') required String aspect,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'user_name') required String userName,
  }) = _PendingIndicatorPreview;

  factory PendingIndicatorPreview.fromJson(Map<String, dynamic> json) =>
      _$PendingIndicatorPreviewFromJson(json);
}

@freezed
abstract class ReviewProgressSummary with _$ReviewProgressSummary {
  const factory ReviewProgressSummary({
    @JsonKey(name: 'total_indicators') required int totalIndicators,
    @JsonKey(name: 'corrected_count') required int correctedCount,
    @FlexibleDoubleConverter() @Default(0) double percentage,
    @JsonKey(name: 'final_correction_score') double? finalCorrectionScore,
    @JsonKey(name: 'pending_indicator_preview')
    @Default(<PendingIndicatorPreview>[])
    List<PendingIndicatorPreview> pendingIndicatorPreview,
  }) = _ReviewProgressSummary;

  factory ReviewProgressSummary.fromJson(Map<String, dynamic> json) =>
      _$ReviewProgressSummaryFromJson(json);
}

@freezed
abstract class AspectModel with _$AspectModel {
  const factory AspectModel({
    required String id,
    @JsonKey(name: 'nama_aspek') required String name,
    @JsonKey(name: 'indikator')
    @Default(<IndicatorModel>[])
    List<IndicatorModel> indicators,
    RoleScore? scores,
  }) = _AspectModel;

  factory AspectModel.fromJson(Map<String, dynamic> json) =>
      _$AspectModelFromJson(json);
}

@freezed
abstract class DomainModel with _$DomainModel {
  const DomainModel._();

  const factory DomainModel({
    required String id,
    @JsonKey(name: 'nama_domain') required String name,
    @JsonKey(name: 'updated_at') required DateTime date,
    @JsonKey(name: 'aspek') required List<AspectModel> aspects,
    required int indicatorCount,
    RoleScore? scores,
  }) = _DomainModel;

  factory DomainModel.fromJson(Map<String, dynamic> json) =>
      _$DomainModelFromJson(json);

  int get aspectsCount => aspects.length;

  DateTime get updatedAt => date;

  int get indicatorsCount => indicatorCount;
}

@freezed
abstract class AssessmentFormModel with _$AssessmentFormModel {
  const AssessmentFormModel._();

  const factory AssessmentFormModel({
    required String id,
    @JsonKey(name: 'nama_formulir') required String title,
    @JsonKey(name: 'created_at') required DateTime date,
    required List<DomainModel> domains,
    @JsonKey(name: 'participating_opd_count') @Default(0) int opdCount,
    RoleScore? scores,
    @JsonKey(name: 'review_progress') ReviewProgressSummary? reviewProgress,
  }) = _AssessmentFormModel;

  factory AssessmentFormModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFormModelFromJson(json);

  int get domainsCount => domains.length;

  String get name => title;

  DateTime get createdAt => date;
}

@freezed
abstract class IndicatorModel with _$IndicatorModel {
  const factory IndicatorModel({
    required String id,
    required String name,
    @JsonKey(name: 'kode_indikator') String? kodeIndikator,
    @JsonKey(name: 'bobot_indikator')
    @FlexibleDoubleConverter()
    @Default(0)
    double bobotIndikator,
    @JsonKey(name: 'level_1_kriteria') String? level1Kriteria,
    @JsonKey(name: 'level_2_kriteria') String? level2Kriteria,
    @JsonKey(name: 'level_3_kriteria') String? level3Kriteria,
    @JsonKey(name: 'level_4_kriteria') String? level4Kriteria,
    @JsonKey(name: 'level_5_kriteria') String? level5Kriteria,
    @JsonKey(name: 'level_1_kriteria_10101') String? level1Kriteria10101,
    @JsonKey(name: 'level_2_kriteria_10101') String? level2Kriteria10101,
    @JsonKey(name: 'level_3_kriteria_10101') String? level3Kriteria10101,
    @JsonKey(name: 'level_4_kriteria_10101') String? level4Kriteria10101,
    @JsonKey(name: 'level_5_kriteria_10101') String? level5Kriteria10101,
    @JsonKey(name: 'level_1_kriteria_10201') String? level1Kriteria10201,
    @JsonKey(name: 'level_2_kriteria_10201') String? level2Kriteria10201,
    @JsonKey(name: 'level_3_kriteria_10201') String? level3Kriteria10201,
    @JsonKey(name: 'level_4_kriteria_10201') String? level4Kriteria10201,
    @JsonKey(name: 'level_5_kriteria_10201') String? level5Kriteria10201,
    RoleScore? scores,
  }) = _IndicatorModel;

  factory IndicatorModel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorModelFromJson(json);
}

typedef KegiatanModel = AssessmentFormModel;

extension IndicatorModelX on IndicatorModel {
  AssessmentIndikator toAssessmentIndikator({
    required String aspectId,
    String? aspectName,
    String? domainName,
  }) {
    return AssessmentIndikator(
      id: int.tryParse(id) ?? 0,
      aspekId: int.tryParse(aspectId) ?? 0,
      kodeIndikator: kodeIndikator,
      namaIndikator: name,
      namaDomain: domainName,
      namaAspek: aspectName,
      bobotIndikator: bobotIndikator,
      level1Kriteria: level1Kriteria,
      level2Kriteria: level2Kriteria,
      level3Kriteria: level3Kriteria,
      level4Kriteria: level4Kriteria,
      level5Kriteria: level5Kriteria,
      level1Kriteria10101: level1Kriteria10101,
      level2Kriteria10101: level2Kriteria10101,
      level3Kriteria10101: level3Kriteria10101,
      level4Kriteria10101: level4Kriteria10101,
      level5Kriteria10101: level5Kriteria10101,
      level1Kriteria10201: level1Kriteria10201,
      level2Kriteria10201: level2Kriteria10201,
      level3Kriteria10201: level3Kriteria10201,
      level4Kriteria10201: level4Kriteria10201,
      level5Kriteria10201: level5Kriteria10201,
    );
  }
}
