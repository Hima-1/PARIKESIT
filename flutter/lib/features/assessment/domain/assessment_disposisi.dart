import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_disposisi.freezed.dart';
part 'assessment_disposisi.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DisposisiStatus { sent, returned, approved, rejected }

@freezed
abstract class AssessmentDisposisi with _$AssessmentDisposisi {
  const factory AssessmentDisposisi({
    required int id,
    @JsonKey(name: 'formulir_id') required int formulirId,
    @JsonKey(name: 'indikator_id') int? indikatorId,
    @JsonKey(name: 'from_profile_id') int? fromUserId,
    @JsonKey(name: 'to_profile_id') int? toUserId,
    @JsonKey(name: 'assigned_profile_id') int? assignedUserId,
    required DisposisiStatus status,
    String? catatan,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AssessmentDisposisi;

  factory AssessmentDisposisi.fromJson(Map<String, dynamic> json) =>
      _$AssessmentDisposisiFromJson(json);
}
