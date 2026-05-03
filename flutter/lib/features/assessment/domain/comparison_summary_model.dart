import 'package:freezed_annotation/freezed_annotation.dart';

part 'comparison_summary_model.freezed.dart';
part 'comparison_summary_model.g.dart';

@freezed
abstract class ComparisonSummaryModel with _$ComparisonSummaryModel {
  const factory ComparisonSummaryModel({
    @JsonKey(name: 'opd_id') required int opdId,
    @JsonKey(name: 'nama_opd') required String opdName,
    @JsonKey(name: 'skor_mandiri') required double skorMandiri,
    @JsonKey(name: 'skor_walidata') required double skorWalidata,
    @JsonKey(name: 'skor_bps') required double skorBps,
  }) = _ComparisonSummaryModel;

  factory ComparisonSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ComparisonSummaryModelFromJson(json);
}
