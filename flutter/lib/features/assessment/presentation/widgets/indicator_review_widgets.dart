import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/maturity_level.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/assessment/domain/assessment_indikator.dart';
import 'package:parikesit/features/assessment/presentation/helpers/review_route_context.dart';
import 'package:parikesit/features/assessment/presentation/models/evidence_attachment.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';
import 'package:parikesit/features/assessment/presentation/widgets/comparison_score_card.dart';
import 'package:parikesit/features/assessment/presentation/widgets/evaluation_note_card.dart';
import 'package:parikesit/features/assessment/presentation/widgets/evidence_link_tile.dart';

class IndicatorReviewCounter extends StatelessWidget {
  const IndicatorReviewCounter({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  final int currentIndex;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: AppSpacing.pH16,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.sogan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${currentIndex + 1} / $totalCount',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.sogan,
            ),
          ),
        ),
      ),
    );
  }
}

class IndicatorReviewContent extends StatelessWidget {
  const IndicatorReviewContent({
    super.key,
    required this.currentData,
    this.isPublicReadOnly = false,
    this.bottomSpacing = 24,
  });

  final IndicatorComparisonData currentData;
  final bool isPublicReadOnly;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IndicatorReviewHeader(
          indikator: currentData.indikator,
          isPublicReadOnly: isPublicReadOnly,
        ),
        AppSpacing.gapH16,
        ComparisonScoreCard(
          nilaiAwal: currentData.opdScore,
          nilaiDiupdate: currentData.walidataScore,
          nilaiEvaluasi: currentData.adminScore,
        ),
        AppSpacing.gapH24,
        _IndicatorLevelCriteriaSection(currentData: currentData),
        AppSpacing.gapH24,
        _IndicatorEvidenceSection(currentData: currentData),
        AppSpacing.gapH24,
        _IndicatorEvaluationNotesSection(currentData: currentData),
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}

class IndicatorReviewNavigationFooter extends StatelessWidget {
  const IndicatorReviewNavigationFooter({
    super.key,
    required this.activityId,
    required this.domainId,
    required this.currentIndex,
    required this.indicatorComparisons,
    required this.isSelfReview,
    this.isPublicReadOnly = false,
    this.opdId,
    this.hasMissingReviewContext = false,
    this.actionChild,
  });

  final String activityId;
  final String domainId;
  final int currentIndex;
  final List<IndicatorComparisonData> indicatorComparisons;
  final bool isSelfReview;
  final bool isPublicReadOnly;
  final String? opdId;
  final bool hasMissingReviewContext;
  final Widget? actionChild;

  @override
  Widget build(BuildContext context) {
    final bool hasPrevious = currentIndex > 0;
    final bool hasNext = currentIndex < indicatorComparisons.length - 1;
    final Widget content = Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actionChild != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: actionChild!,
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.sogan.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavigationButton(
                    onPressed: hasPrevious
                        ? () => _handleNavigation(context, currentIndex - 1)
                        : null,
                    icon: LucideIcons.arrowLeft,
                    label: 'SEBELUMNYA',
                    isNext: false,
                  ),
                  _NavigationButton(
                    onPressed: hasNext
                        ? () => _handleNavigation(context, currentIndex + 1)
                        : null,
                    icon: LucideIcons.chevronRight,
                    label: 'SELANJUTNYA',
                    isNext: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }

  void _handleNavigation(BuildContext context, int newIndex) {
    if (hasMissingReviewContext) {
      showMissingReviewOpdContextFeedback(context);
      return;
    }

    HapticFeedback.lightImpact();
    final IndicatorComparisonData newData = indicatorComparisons[newIndex];
    context.pushReplacement(
      isPublicReadOnly
          ? RouteConstants.buildPublicAssessmentIndicatorPath(
              activityId: activityId,
              opdId: opdId!,
              domainId: domainId,
              indicatorId: newData.indikator.id.toString(),
            )
          : RouteConstants.buildAssessmentIndicatorPath(
              activityId: activityId,
              domainId: domainId,
              indicatorId: newData.indikator.id.toString(),
              opdId: opdId,
              isSelfReview: isSelfReview,
            ),
      extra: <String, dynamic>{
        'data': newData,
        'comparisons': indicatorComparisons,
        'currentIndex': newIndex,
      },
    );
  }
}

class _IndicatorReviewHeader extends StatelessWidget {
  const _IndicatorReviewHeader({
    required this.indikator,
    required this.isPublicReadOnly,
  });

  final AssessmentIndikator indikator;
  final bool isPublicReadOnly;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return EthnoCard(
      isFlat: true,
      showBatikAccent: true,
      padding: AppSpacing.pAll20,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${isPublicReadOnly ? 'INDIKATOR PUBLIK' : 'KODE INDIKATOR'} ${indikator.kodeIndikator ?? indikator.id}',
            style: textTheme.labelSmall?.copyWith(
              color: isPublicReadOnly ? AppTheme.sogan : AppTheme.gold,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.gapH12,
          Text(
            indikator.namaIndikator,
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w900,
              height: 1.3,
            ),
          ),
          if ((indikator.namaDomain ?? '').isNotEmpty ||
              (indikator.namaAspek ?? '').isNotEmpty) ...[
            AppSpacing.gapH12,
            Text(
              [
                if ((indikator.namaDomain ?? '').isNotEmpty)
                  indikator.namaDomain,
                if ((indikator.namaAspek ?? '').isNotEmpty) indikator.namaAspek,
              ].join(' > '),
              style: textTheme.bodySmall?.copyWith(
                color: AppTheme.neutral,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IndicatorLevelCriteriaSection extends StatelessWidget {
  const _IndicatorLevelCriteriaSection({required this.currentData});

  final IndicatorComparisonData currentData;

  @override
  Widget build(BuildContext context) {
    final AssessmentIndikator indikator = currentData.indikator;
    final textTheme = Theme.of(context).textTheme;
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Tingkat Kriteria',
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppSpacing.gapH12,
        ...List<Widget>.generate(5, (int index) {
          final int level = index + 1;
          final bool isOpdMatch = currentData.opdScore.round() == level;
          final bool isWalidataMatch =
              currentData.walidataScore.round() == level;
          final bool isAdminMatch = currentData.adminScore.round() == level;
          final bool isRelevant = isOpdMatch || isWalidataMatch || isAdminMatch;

          Color borderColor = isRelevant
              ? AppTheme.sogan
              : AppTheme.sogan.withValues(alpha: 0.1);
          Color indicatorColor = AppTheme.neutral.withValues(alpha: 0.3);

          if (isAdminMatch) {
            borderColor = AppTheme.success;
            indicatorColor = AppTheme.success;
          } else if (isWalidataMatch) {
            borderColor = AppTheme.gold;
            indicatorColor = AppTheme.gold;
          } else if (isOpdMatch) {
            borderColor = AppTheme.sogan;
            indicatorColor = AppTheme.sogan;
          }

          return EthnoCard(
            isFlat: true,
            margin: const EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.zero,
            borderColor: borderColor,
            child: ExpansionTile(
              key: PageStorageKey<String>('level_$level'),
              initiallyExpanded: isRelevant,
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              collapsedShape: const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: indicatorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: isRelevant
                      ? Border.all(color: indicatorColor.withValues(alpha: 0.3))
                      : null,
                ),
                child: Text(
                  '$level',
                  style: textTheme.titleMedium?.copyWith(
                    color: isRelevant ? indicatorColor : AppTheme.neutral,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              title: Text(
                level.maturityFullLabel.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: isRelevant ? FontWeight.w900 : FontWeight.w700,
                  color: isRelevant ? AppTheme.sogan : AppTheme.neutral,
                  letterSpacing: 0.5,
                  fontSize:
                      Theme.of(context).textTheme.bodySmall?.fontSize ?? 10,
                ),
              ),
              trailing: isRelevant
                  ? Wrap(
                      spacing: 4,
                      children: [
                        if (isOpdMatch)
                          const _RoleBadge(label: 'OPD', color: AppTheme.sogan),
                        if (isWalidataMatch)
                          const _RoleBadge(label: 'WALI', color: AppTheme.gold),
                        if (isAdminMatch)
                          const _RoleBadge(
                            label: 'BPS',
                            color: AppTheme.success,
                          ),
                      ],
                    )
                  : Icon(
                      LucideIcons.chevronDown,
                      size: 20,
                      color: AppTheme.neutral.withValues(alpha: 0.5),
                    ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Container(
                    padding: AppSpacing.pAll12,
                    decoration: BoxDecoration(
                      color: AppTheme.shellSurfaceSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      indikator.effectiveLevelKriteria(
                            level,
                            indicatorCode: indikator.kodeIndikator,
                          ) ??
                          'Kriteria level $level belum tersedia.',
                      style: textTheme.bodySmall?.copyWith(
                        height: 1.6,
                        color: AppTheme.sogan.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );

    return content;
  }
}

class _IndicatorEvidenceSection extends StatelessWidget {
  const _IndicatorEvidenceSection({required this.currentData});

  final IndicatorComparisonData currentData;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Bukti Dukung',
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppSpacing.gapH12,
        if (currentData.evidences.isEmpty)
          EthnoCard(
            isFlat: true,
            padding: AppSpacing.pAll24,
            child: Center(
              child: Text(
                'Belum ada bukti dukung yang diunggah.',
                style: textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
              ),
            ),
          )
        else
          ...currentData.evidences.map(
            (EvidenceAttachment evidence) => EvidenceLinkTile(
              fileName: evidence.fileName,
              fileUrl: evidence.fileUrl,
              fileSizeLabel: evidence.fileSizeLabel,
            ),
          ),
      ],
    );

    return content;
  }
}

class _IndicatorEvaluationNotesSection extends StatelessWidget {
  const _IndicatorEvaluationNotesSection({required this.currentData});

  final IndicatorComparisonData currentData;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<RoleEvaluationNote> notes = currentData.evaluationNotes.isEmpty
        ? const <RoleEvaluationNote>[
            RoleEvaluationNote(
              role: 'OPD',
              note: 'Belum ada catatan evaluasi dari OPD.',
            ),
            RoleEvaluationNote(
              role: 'Walidata',
              note: 'Belum ada catatan evaluasi dari Walidata.',
            ),
            RoleEvaluationNote(
              role: 'Admin',
              note: 'Belum ada catatan evaluasi dari Admin.',
            ),
          ]
        : currentData.evaluationNotes;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Catatan Evaluasi per Peran',
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppSpacing.gapH12,
        ...notes.map(
          (RoleEvaluationNote note) =>
              EvaluationNoteCard(role: note.role, note: note.note),
        ),
      ],
    );

    return content;
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isNext,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    final textTheme = Theme.of(context).textTheme;
    final Color color = isEnabled
        ? AppTheme.sogan
        : AppTheme.neutral.withValues(alpha: 0.4);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            if (!isNext) ...[
              Icon(icon, size: 14, color: color),
              AppSpacing.gapW8,
            ],
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: color,
              ),
            ),
            if (isNext) ...[
              AppSpacing.gapW8,
              Icon(icon, size: 14, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
