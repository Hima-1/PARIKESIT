import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_assessment_progress.freezed.dart';
part 'admin_assessment_progress.g.dart';

@freezed
abstract class AdminAssessmentProgress with _$AdminAssessmentProgress {
  const factory AdminAssessmentProgress({
    required int id,
    @JsonKey(name: 'nama') required String name,
    @JsonKey(name: 'tanggal') required DateTime date,
    required int opdFilledCount,
    required int opdTotalCount,
    required int walidataCorrectedCount,
    required int walidataTotalCount,
  }) = _AdminAssessmentProgress;

  factory AdminAssessmentProgress.fromJson(Map<String, dynamic> json) =>
      _$AdminAssessmentProgressFromJson(json);
}
