import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:parikesit/features/assessment/presentation/models/evidence_attachment.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';

List<IndicatorComparisonData> resolveIndicatorComparisonList({
  required List<IndicatorComparisonData> snapshots,
  required AssessmentFormState? formState,
}) {
  final List<IndicatorComparisonData> latestSnapshots =
      _comparisonSnapshotsFromFormState(formState);
  final Map<int, IndicatorComparisonData> latestById = {
    for (final IndicatorComparisonData item in latestSnapshots)
      item.indikator.id: item,
  };

  final Set<int> seenIds = <int>{};
  final List<IndicatorComparisonData> resolved = <IndicatorComparisonData>[];

  for (final IndicatorComparisonData snapshot in snapshots) {
    final IndicatorComparisonData base = _preferLatestComparisonData(
      latest: latestById[snapshot.indikator.id],
      fallback: snapshot,
    )!;
    seenIds.add(base.indikator.id);
    resolved.add(
      _overlayIndicatorComparisonData(
        base: base,
        livePenilaian: formState?.draftsByIndikatorId[base.indikator.id],
      ),
    );
  }

  for (final IndicatorComparisonData latest in latestSnapshots) {
    if (seenIds.contains(latest.indikator.id)) {
      continue;
    }
    resolved.add(
      _overlayIndicatorComparisonData(
        base: latest,
        livePenilaian: formState?.draftsByIndikatorId[latest.indikator.id],
      ),
    );
  }

  return resolved;
}

IndicatorComparisonData? resolveIndicatorComparisonData({
  required String indicatorId,
  required IndicatorComparisonData? routeData,
  required List<IndicatorComparisonData> snapshots,
  required AssessmentFormState? formState,
}) {
  final int parsedIndicatorId = int.tryParse(indicatorId) ?? -1;
  final IndicatorComparisonData? latest = _comparisonSnapshotsFromFormState(
    formState,
  ).where((item) => item.indikator.id == parsedIndicatorId).firstOrNull;
  final IndicatorComparisonData? snapshot = snapshots
      .where((item) => item.indikator.id == parsedIndicatorId)
      .firstOrNull;
  final IndicatorComparisonData? base = _preferLatestComparisonData(
    latest: latest,
    fallback: snapshot ?? routeData,
  );
  if (base == null) {
    return null;
  }

  return _overlayIndicatorComparisonData(
    base: base,
    livePenilaian: formState?.draftsByIndikatorId[base.indikator.id],
  );
}

List<IndicatorComparisonData> _comparisonSnapshotsFromFormState(
  AssessmentFormState? formState,
) {
  final formulir = formState?.formulir;
  if (formulir == null) {
    return const <IndicatorComparisonData>[];
  }

  final List<IndicatorComparisonData> results = <IndicatorComparisonData>[];
  for (final domain in formulir.domains) {
    for (final aspect in domain.aspects) {
      for (final indicator in aspect.indicators) {
        final int indicatorId = int.tryParse(indicator.id) ?? 0;
        final Penilaian? penilaian =
            formState?.draftsByIndikatorId[indicatorId];
        results.add(
          IndicatorComparisonData(
            indikator: indicator.toAssessmentIndikator(
              aspectId: aspect.id,
              aspectName: aspect.name,
              domainName: domain.name,
            ),
            opdScore: penilaian?.nilai ?? indicator.scores?.opd ?? 0,
            walidataScore:
                penilaian?.nilaiDiupdate ?? indicator.scores?.walidata ?? 0,
            adminScore: penilaian?.nilaiKoreksi ?? indicator.scores?.admin ?? 0,
            namaAspek: aspect.name,
            evidences: buildEvidenceAttachments(penilaian?.buktiDukung),
            evaluationNotes: <RoleEvaluationNote>[
              if ((penilaian?.catatan ?? '').isNotEmpty)
                RoleEvaluationNote(role: 'OPD', note: penilaian!.catatan!),
              if ((penilaian?.catatanKoreksi ?? '').isNotEmpty)
                RoleEvaluationNote(
                  role: 'Walidata',
                  note: penilaian!.catatanKoreksi!,
                ),
              if ((penilaian?.evaluasi ?? '').isNotEmpty)
                RoleEvaluationNote(role: 'Admin', note: penilaian!.evaluasi!),
            ],
          ),
        );
      }
    }
  }

  return results;
}

IndicatorComparisonData? _preferLatestComparisonData({
  required IndicatorComparisonData? latest,
  required IndicatorComparisonData? fallback,
}) {
  if (latest == null) {
    return fallback;
  }
  if (fallback == null) {
    return latest;
  }

  return IndicatorComparisonData(
    indikator: latest.indikator,
    opdScore: latest.opdScore > 0 ? latest.opdScore : fallback.opdScore,
    walidataScore: latest.walidataScore > 0
        ? latest.walidataScore
        : fallback.walidataScore,
    adminScore: latest.adminScore > 0 ? latest.adminScore : fallback.adminScore,
    namaAspek: latest.namaAspek ?? fallback.namaAspek,
    evidences: latest.evidences.isNotEmpty
        ? latest.evidences
        : fallback.evidences,
    evaluationNotes: latest.evaluationNotes.isNotEmpty
        ? latest.evaluationNotes
        : fallback.evaluationNotes,
  );
}

IndicatorComparisonData _overlayIndicatorComparisonData({
  required IndicatorComparisonData base,
  required Penilaian? livePenilaian,
}) {
  if (livePenilaian == null) {
    return base;
  }

  final Map<String, String> notesByRole = <String, String>{
    for (final RoleEvaluationNote note in base.evaluationNotes)
      note.role: note.note,
  };
  if ((livePenilaian.catatan ?? '').isNotEmpty) {
    notesByRole['OPD'] = livePenilaian.catatan!;
  }
  if ((livePenilaian.catatanKoreksi ?? '').isNotEmpty) {
    notesByRole['Walidata'] = livePenilaian.catatanKoreksi!;
  }
  if ((livePenilaian.evaluasi ?? '').isNotEmpty) {
    notesByRole['Admin'] = livePenilaian.evaluasi!;
  }

  return IndicatorComparisonData(
    indikator: base.indikator,
    opdScore: livePenilaian.nilai,
    walidataScore: livePenilaian.nilaiDiupdate ?? base.walidataScore,
    adminScore: livePenilaian.nilaiKoreksi ?? base.adminScore,
    namaAspek: base.namaAspek,
    evidences: livePenilaian.buktiDukung != null
        ? buildEvidenceAttachments(livePenilaian.buktiDukung)
        : base.evidences,
    evaluationNotes: notesByRole.entries
        .map((entry) => RoleEvaluationNote(role: entry.key, note: entry.value))
        .toList(growable: false),
  );
}
