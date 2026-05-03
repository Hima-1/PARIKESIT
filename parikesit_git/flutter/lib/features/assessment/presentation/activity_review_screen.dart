import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/ethno_patterns.dart';
import 'package:parikesit/core/widgets/section_header.dart';
import 'package:parikesit/features/assessment/domain/assessment_domain.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:parikesit/features/assessment/presentation/controller/opd_selection_controller.dart';
import 'package:parikesit/features/assessment/presentation/models/evidence_attachment.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';
import 'package:parikesit/features/assessment/presentation/widgets/bps_data_table.dart';
import 'package:parikesit/features/assessment/presentation/widgets/comparison_score_card.dart';

class ActivityReviewScreen extends ConsumerStatefulWidget {
  const ActivityReviewScreen({
    super.key,
    required this.activityId,
    this.opdId,
    this.activity,
    this.isPublicReadOnly = false,
  });

  final String activityId;
  final int? opdId;
  final AssessmentFormModel? activity;
  final bool isPublicReadOnly;

  bool get isSelfReview => opdId == null;

  @override
  ConsumerState<ActivityReviewScreen> createState() =>
      _ActivityReviewScreenState();
}

class _ActivityReviewScreenState extends ConsumerState<ActivityReviewScreen> {
  @override
  void initState() {
    super.initState();
    _loadOpdIndicators();
  }

  @override
  void didUpdateWidget(covariant ActivityReviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activityId != widget.activityId ||
        oldWidget.opdId != widget.opdId) {
      _loadOpdIndicators();
    }
  }

  void _loadOpdIndicators() {
    final int? opdId = widget.opdId;
    final int? activityIdInt = int.tryParse(widget.activityId);
    if (opdId == null || activityIdInt == null || widget.isPublicReadOnly) {
      return;
    }

    Future<void>.microtask(
      () => ref
          .read(assessmentFormControllerProvider(activityIdInt).notifier)
          .loadIndicatorsForOpd(opdId),
    );
  }

  Future<void> _handleRefresh() async {
    final int? activityIdInt = int.tryParse(widget.activityId);
    if (activityIdInt == null) return;

    final int? opdId = widget.opdId;
    if (widget.isPublicReadOnly && opdId != null) {
      ref.invalidate(
        publicAssessmentDetailProvider((
          activityId: activityIdInt,
          opdId: opdId,
        )),
      );
      await ref.read(
        publicAssessmentDetailProvider((
          activityId: activityIdInt,
          opdId: opdId,
        )).future,
      );
      return;
    }

    if (opdId != null) {
      ref.invalidate(
        opdStatsProvider((activityId: activityIdInt, opdId: opdId)),
      );
      ref.invalidate(
        opdDomainScoresProvider((activityId: activityIdInt, opdId: opdId)),
      );

      await ref
          .read(assessmentFormControllerProvider(activityIdInt).notifier)
          .loadIndicatorsForOpd(opdId);

      await Future.wait([
        ref.read(
          opdStatsProvider((activityId: activityIdInt, opdId: opdId)).future,
        ),
        ref.read(
          opdDomainScoresProvider((
            activityId: activityIdInt,
            opdId: opdId,
          )).future,
        ),
      ]);
      return;
    }

    ref.invalidate(assessmentFormControllerProvider(activityIdInt));
    await ref.read(assessmentFormControllerProvider(activityIdInt).future);
  }

  Widget _buildRefreshableBody({required Widget child}) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.sogan,
      child: child,
    );
  }

  Widget _buildCenteredScrollableMessage({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pPage,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: child),
            ),
          ],
        );
      },
    );
  }

  Widget _wrapFlowBody({required Widget child}) {
    if (!widget.isPublicReadOnly) {
      return child;
    }

    return KawungBackground(opacity: 0.03, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final int activityIdInt = int.tryParse(widget.activityId) ?? 0;
    final AsyncValue<AssessmentFormState> formState = widget.isPublicReadOnly
        ? ref.watch(
            publicAssessmentDetailProvider((
              activityId: activityIdInt,
              opdId: widget.opdId ?? 0,
            )),
          )
        : ref.watch(assessmentFormControllerProvider(activityIdInt));

    final Map<String, double?>? opdStats =
        widget.isPublicReadOnly || widget.opdId == null
        ? null
        : ref
              .watch(
                opdStatsProvider((
                  activityId: activityIdInt,
                  opdId: widget.opdId!,
                )),
              )
              .value;
    final Map<String, RoleScore>? opdDomainScores =
        widget.isPublicReadOnly || widget.opdId == null
        ? null
        : ref
              .watch(
                opdDomainScoresProvider((
                  activityId: activityIdInt,
                  opdId: widget.opdId!,
                )),
              )
              .value;

    return formState.when(
      loading: () => Scaffold(
        backgroundColor: widget.isPublicReadOnly
            ? AppTheme.merang
            : Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.isPublicReadOnly ? 'Hasil Penilaian OPD' : 'Review Kegiatan',
          ),
        ),
        body: _wrapFlowBody(
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppTheme.sogan),
            ),
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: widget.isPublicReadOnly
            ? AppTheme.merang
            : Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.isPublicReadOnly ? 'Hasil Penilaian OPD' : 'Review Kegiatan',
          ),
        ),
        body: _wrapFlowBody(
          child: _buildRefreshableBody(
            child: _buildCenteredScrollableMessage(
              child: Text(
                'Gagal memuat data: $err',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
              ),
            ),
          ),
        ),
      ),
      data: (state) {
        final AssessmentFormModel? currentActivity =
            state.formulir ?? widget.activity;
        final String screenTitle = widget.isPublicReadOnly
            ? 'Hasil Penilaian OPD'
            : widget.opdId == null
            ? 'Tinjau Penilaian'
            : 'Tinjau OPD #${widget.opdId}';

        if (currentActivity == null) {
          return Scaffold(
            backgroundColor: widget.isPublicReadOnly
                ? AppTheme.merang
                : Colors.transparent,
            appBar: AppBar(title: Text(screenTitle)),
            body: _wrapFlowBody(
              child: _buildRefreshableBody(
                child: _buildCenteredScrollableMessage(
                  child: Text(
                    widget.isPublicReadOnly
                        ? 'Data hasil penilaian tidak tersedia.'
                        : 'Data review kegiatan tidak tersedia.',
                  ),
                ),
              ),
            ),
          );
        }

        final List<DomainModel> domains = currentActivity.domains;
        final bool hasNilaiAwal =
            opdStats?['opd'] != null || currentActivity.scores?.opd != null;
        final bool hasNilaiDiupdate =
            opdStats?['walidata'] != null ||
            currentActivity.scores?.walidata != null;
        final bool hasNilaiEvaluasi =
            opdStats?['admin'] != null || currentActivity.scores?.admin != null;
        final double nilaiAwal =
            opdStats?['opd'] ?? currentActivity.scores?.opd ?? 0;
        final double nilaiDiupdate =
            opdStats?['walidata'] ?? currentActivity.scores?.walidata ?? 0;
        final double nilaiEvaluasi =
            opdStats?['admin'] ?? currentActivity.scores?.admin ?? 0;

        return Scaffold(
          backgroundColor: widget.isPublicReadOnly
              ? AppTheme.merang
              : Colors.transparent,
          appBar: AppBar(title: Text(screenTitle)),
          body: _wrapFlowBody(
            child: _buildRefreshableBody(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppSpacing.pPage,
                children: [
                  if (widget.opdId != null) ...[
                    Text(
                      widget.isPublicReadOnly
                          ? 'REKAP HASIL OPD'
                          : 'REKAP PENILAIAN OPD',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.neutral,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    AppSpacing.gapH12,
                  ],
                  ComparisonScoreCard(
                    nilaiAwal: nilaiAwal,
                    nilaiDiupdate: nilaiDiupdate,
                    nilaiEvaluasi: nilaiEvaluasi,
                    hasNilaiAwal: hasNilaiAwal,
                    hasNilaiDiupdate: hasNilaiDiupdate,
                    hasNilaiEvaluasi: hasNilaiEvaluasi,
                  ),
                  AppSpacing.gapH24,
                  const SectionHeader(title: 'Ringkasan Nilai Domain'),
                  AppSpacing.gapH12,
                  BpsDataTable(
                    columns: const ['Domain', 'Skor Akhir'],
                    rows: domains
                        .map(
                          (DomainModel domain) => [
                            domain.name,
                            _formatDomainSummaryScore(
                              resolveDomainSummaryScore(
                                domain: domain,
                                liveScoresByDomainId: opdDomainScores,
                              ),
                            ),
                          ],
                        )
                        .toList(growable: false),
                    onRowTap: (int rowIndex) {
                      final DomainModel selectedDomain = domains[rowIndex];
                      final String? opdId = widget.opdId?.toString();

                      if (widget.isPublicReadOnly) {
                        if (opdId == null) {
                          return;
                        }

                        context.push(
                          RouteConstants.buildPublicAssessmentDomainPath(
                            activityId: widget.activityId,
                            opdId: opdId,
                            domainId: selectedDomain.id,
                          ),
                          extra: <String, dynamic>{
                            'domain': _toAssessmentDomain(
                              selectedDomain,
                              rowIndex,
                            ),
                            'indicatorComparisons':
                                buildIndicatorComparisonsForDomain(
                                  selectedDomain,
                                  state.draftsByIndikatorId,
                                ),
                          },
                        );
                        return;
                      }

                      context.push(
                        RouteConstants.buildAssessmentDomainPath(
                          activityId: widget.activityId,
                          domainId: selectedDomain.id,
                          opdId: opdId,
                          isSelfReview: widget.isSelfReview,
                        ),
                        extra: <String, dynamic>{
                          'domain': _toAssessmentDomain(
                            selectedDomain,
                            rowIndex,
                          ),
                          'indicatorComparisons':
                              buildIndicatorComparisonsForDomain(
                                selectedDomain,
                                state.draftsByIndikatorId,
                              ),
                        },
                      );
                    },
                  ),
                  AppSpacing.gapH24,
                  _PenilaiIdentitySection(
                    activityTitle: currentActivity.title,
                    isSelfReview: widget.isSelfReview,
                    isPublicReadOnly: widget.isPublicReadOnly,
                  ),
                  AppSpacing.gapH32,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AssessmentDomain _toAssessmentDomain(DomainModel domain, int fallbackId) {
    return AssessmentDomain(
      id: int.tryParse(domain.id) ?? fallbackId + 1,
      namaDomain: domain.name,
      bobotDomain: 0,
    );
  }

  String _formatDomainSummaryScore(double? value) {
    if (value == null) return '-';
    return value.toStringAsFixed(2);
  }
}

double? resolveDomainSummaryScore({
  required DomainModel domain,
  required Map<String, RoleScore>? liveScoresByDomainId,
}) {
  final RoleScore? liveScore = liveScoresByDomainId?[domain.id];
  if (liveScore != null) {
    return liveScore.admin ?? liveScore.walidata ?? liveScore.opd;
  }

  final RoleScore? snapshotScore = domain.scores;
  return snapshotScore?.admin ?? snapshotScore?.walidata ?? snapshotScore?.opd;
}

List<IndicatorComparisonData> buildIndicatorComparisonsForDomain(
  DomainModel domain,
  Map<int, Penilaian> assessments,
) {
  final List<IndicatorComparisonData> results = <IndicatorComparisonData>[];

  for (final AspectModel aspect in domain.aspects) {
    for (final IndicatorModel indicator in aspect.indicators) {
      final int indicatorId = int.tryParse(indicator.id) ?? 0;
      final Penilaian? assessment = assessments[indicatorId];

      results.add(
        IndicatorComparisonData(
          indikator: indicator.toAssessmentIndikator(
            aspectId: aspect.id,
            aspectName: aspect.name,
            domainName: domain.name,
          ),
          opdScore: assessment?.nilai ?? indicator.scores?.opd ?? 0,
          walidataScore:
              assessment?.nilaiDiupdate ?? indicator.scores?.walidata ?? 0,
          adminScore: assessment?.nilaiKoreksi ?? indicator.scores?.admin ?? 0,
          namaAspek: aspect.name,
          evidences: buildEvidenceAttachments(assessment?.buktiDukung),
          evaluationNotes: <RoleEvaluationNote>[
            if (assessment?.catatan != null && assessment!.catatan!.isNotEmpty)
              RoleEvaluationNote(role: 'OPD', note: assessment.catatan!),
            if (assessment?.catatanKoreksi != null &&
                assessment!.catatanKoreksi!.isNotEmpty)
              RoleEvaluationNote(
                role: 'Walidata',
                note: assessment.catatanKoreksi!,
              ),
            if (assessment?.evaluasi != null &&
                assessment!.evaluasi!.isNotEmpty)
              RoleEvaluationNote(role: 'Admin', note: assessment.evaluasi!),
          ],
        ),
      );
    }
  }

  return results;
}

class _PenilaiIdentitySection extends StatelessWidget {
  const _PenilaiIdentitySection({
    required this.activityTitle,
    required this.isSelfReview,
    required this.isPublicReadOnly,
  });

  final String activityTitle;
  final bool isSelfReview;
  final bool isPublicReadOnly;

  @override
  Widget build(BuildContext context) {
    final Widget tile = ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      iconColor: AppTheme.sogan,
      collapsedIconColor: AppTheme.sogan,
      shape: const RoundedRectangleBorder(side: BorderSide.none),
      collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
      title: Text(
        'DATA IDENTITAS PENILAI',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTheme.sogan,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.1,
        ),
      ),
      children: [
        _IdentityRow(
          label: 'Reviewer',
          value: isPublicReadOnly
              ? 'Publik (read-only)'
              : isSelfReview
              ? 'OPD (read-only)'
              : 'Walidata / Admin BPS',
        ),
        _IdentityRow(
          label: 'Ruang Lingkup',
          value: isPublicReadOnly
              ? 'Hasil akhir milik satu OPD'
              : isSelfReview
              ? 'Penilaian selesai milik sendiri'
              : 'Penilaian selesai lintas OPD',
        ),
        _IdentityRow(label: 'Kegiatan', value: activityTitle),
      ],
    );

    return EthnoCard(isFlat: true, padding: EdgeInsets.zero, child: tile);
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: AppTheme.neutral,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: AppTheme.sogan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
