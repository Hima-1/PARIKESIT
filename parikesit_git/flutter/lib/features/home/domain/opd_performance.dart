import 'package:freezed_annotation/freezed_annotation.dart';

part 'opd_performance.freezed.dart';
part 'opd_performance.g.dart';

@freezed
abstract class OpdPerformance with _$OpdPerformance {
  const factory OpdPerformance({
    @JsonKey(name: 'opd_name') required String opdName,
    required double score,
  }) = _OpdPerformance;

  factory OpdPerformance.fromJson(Map<String, dynamic> json) =>
      _$OpdPerformanceFromJson(json);
}
