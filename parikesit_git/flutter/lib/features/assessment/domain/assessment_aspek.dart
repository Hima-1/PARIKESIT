import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_aspek.freezed.dart';
part 'assessment_aspek.g.dart';

@freezed
abstract class AssessmentAspek with _$AssessmentAspek {
  const factory AssessmentAspek({
    required int id,
    @JsonKey(name: 'domain_id') required int domainId,
    @JsonKey(name: 'nama_aspek') required String namaAspek,
    @JsonKey(name: 'bobot_aspek') required double bobotAspek,
    @JsonKey(name: 'created_at') @Default(null) DateTime? createdAt,
    @JsonKey(name: 'updated_at') @Default(null) DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') @Default(null) DateTime? deletedAt,
  }) = _AssessmentAspek;

  factory AssessmentAspek.fromJson(Map<String, dynamic> json) =>
      _$AssessmentAspekFromJson(json);
}
