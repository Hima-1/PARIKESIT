import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_domain.freezed.dart';
part 'assessment_domain.g.dart';

@freezed
abstract class AssessmentDomain with _$AssessmentDomain {
  const factory AssessmentDomain({
    required int id,
    @JsonKey(name: 'nama_domain') required String namaDomain,
    @JsonKey(name: 'bobot_domain') required double bobotDomain,
    @JsonKey(name: 'created_at') @Default(null) DateTime? createdAt,
    @JsonKey(name: 'updated_at') @Default(null) DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') @Default(null) DateTime? deletedAt,
  }) = _AssessmentDomain;

  factory AssessmentDomain.fromJson(Map<String, dynamic> json) =>
      _$AssessmentDomainFromJson(json);
}
