import 'package:parikesit/features/assessment/domain/assessment_indikator.dart';
import 'package:parikesit/features/assessment/presentation/models/evidence_attachment.dart';

class IndicatorComparisonData {
  const IndicatorComparisonData({
    required this.indikator,
    required this.opdScore,
    required this.walidataScore,
    required this.adminScore,
    this.namaAspek,
    this.evidences = const <EvidenceAttachment>[],
    this.evaluationNotes = const <RoleEvaluationNote>[],
  });

  factory IndicatorComparisonData.fromJson(Map<String, dynamic> json) {
    return IndicatorComparisonData(
      indikator: AssessmentIndikator.fromJson(
        json['indikator'] as Map<String, dynamic>,
      ),
      opdScore: (json['opdScore'] as num).toDouble(),
      walidataScore: (json['walidataScore'] as num).toDouble(),
      adminScore: (json['adminScore'] as num).toDouble(),
      namaAspek: json['namaAspek'] as String?,
      evidences: ((json['evidences'] as List<dynamic>?) ?? const <dynamic>[])
          .map(
            (dynamic item) =>
                EvidenceAttachment.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      evaluationNotes:
          ((json['evaluationNotes'] as List<dynamic>?) ?? const <dynamic>[])
              .map(
                (dynamic item) =>
                    RoleEvaluationNote.fromJson(item as Map<String, dynamic>),
              )
              .toList(growable: false),
    );
  }

  final AssessmentIndikator indikator;
  final double opdScore;
  final double walidataScore;
  final double adminScore;
  final String? namaAspek;
  final List<EvidenceAttachment> evidences;
  final List<RoleEvaluationNote> evaluationNotes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'indikator': indikator.toJson(),
      'opdScore': opdScore,
      'walidataScore': walidataScore,
      'adminScore': adminScore,
      'namaAspek': namaAspek,
      'evidences': evidences
          .map((EvidenceAttachment evidence) => evidence.toJson())
          .toList(growable: false),
      'evaluationNotes': evaluationNotes
          .map((RoleEvaluationNote note) => note.toJson())
          .toList(growable: false),
    };
  }
}

class RoleEvaluationNote {
  const RoleEvaluationNote({required this.role, required this.note});

  factory RoleEvaluationNote.fromJson(Map<String, dynamic> json) {
    return RoleEvaluationNote(
      role: json['role'] as String,
      note: json['note'] as String,
    );
  }

  final String role;
  final String note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'role': role, 'note': note};
  }
}
