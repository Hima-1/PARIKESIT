import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/status_banner.dart';

import '../../../core/router/route_constants.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/ethno_patterns.dart';
import '../domain/assessment_domain.dart';
import 'controller/assessment_controller.dart';
import 'helpers/indicator_review_resolver.dart';
import 'helpers/review_route_context.dart';
import 'models/indicator_review_models.dart';
import 'widgets/compact_comparison_score_card.dart';

class DomainCorrectionListScreen extends ConsumerWidget {
  const DomainCorrectionListScreen({
    super.key,
    required this.activityId,
    required this.domainId,
    required this.isSelfReview,
    this.isPublicReadOnly = false,
    this.opdId,
    this.domain,
    this.indicatorComparisons = const <IndicatorComparisonData>[],
  });

  final String activityId;
  final String domainId;
  final bool isSelfReview;
  final bool isPublicReadOnly;
  final String? opdId;
  final AssessmentDomain? domain;
  final List<IndicatorComparisonData> indicatorComparisons;

  Widget _wrapFlowBody({required Widget child}) {
    if (!isPublicReadOnly) {
      return child;
    }

    return KawungBackground(opacity: 0.03, child: child);
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    final int? activityIdInt = int.tryParse(activityId);
    if (activityIdInt == null) {
      return;
    }

    if (isPublicReadOnly) {
      final int? opdIdInt = int.tryParse(opdId ?? '');
      if (opdIdInt == null) {
        return;
      }
      final future = ref.refresh(
        publicAssessmentDetailProvider((
          activityId: activityIdInt,
          opdId: opdIdInt,
        )).future,
      );
      await future;
      return;
    }

    final future = ref.refresh(
      assessmentFormControllerProvider(activityIdInt).future,
    );
    await future;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AssessmentDomain? currentDomain = domain;
    final String? resolvedOpdId = resolveReviewOpdId(
      context,
      isSelfReview: isSelfReview,
      opdId: opdId,
    );
    final bool hasMissingReviewContext = !isSelfReview && resolvedOpdId == null;

    if (currentDomain == null) {
      return _buildMissingDomainScaffold(ref);
    }

    final int? activityIdInt = int.tryParse(activityId);
    final int? opdIdInt = int.tryParse(resolvedOpdId ?? opdId ?? '');
    final formState = _resolveFormState(ref, activityIdInt, opdIdInt);
    final List<IndicatorComparisonData> resolvedComparisons =
        resolveIndicatorComparisonList(
          snapshots: indicatorComparisons,
          formState: formState,
        );
    final groupedIndicators = _groupComparisonsByAspect(resolvedComparisons);

    final int totalIndicators = resolvedComparisons.length;
    final int correctedIndicators = resolvedComparisons
        .where((item) => item.walidataScore > 0)
        .length;

    return Scaffold(
      backgroundColor: isPublicReadOnly ? AppTheme.merang : Colors.transparent,
      appBar: AppBar(
        title: Text(isPublicReadOnly ? 'Hasil Domain OPD' : 'Tinjau Domain'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: _wrapFlowBody(
          child: Column(
            children: [
              if (hasMissingReviewContext)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: StatusBanner(
                    message: missingReviewOpdContextMessage,
                    type: StatusBannerType.warning,
                    icon: Icons.link_off_rounded,
                  ),
                ),
              _buildDomainHeader(
                context,
                currentDomain,
                totalIndicators,
                correctedIndicators,
              ),
              Expanded(
                child: _buildIndicatorGroups(
                  context,
                  comparisons: resolvedComparisons,
                  groupedIndicators: groupedIndicators,
                  resolvedOpdId: resolvedOpdId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold _buildMissingDomainScaffold(WidgetRef ref) {
    return Scaffold(
      backgroundColor: isPublicReadOnly ? AppTheme.merang : Colors.transparent,
      appBar: AppBar(
        title: Text(isPublicReadOnly ? 'Hasil Domain OPD' : 'Tinjau Domain'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: _wrapFlowBody(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 240),
              Center(child: Text('Data domain tidak tersedia.')),
            ],
          ),
        ),
      ),
    );
  }

  AssessmentFormState? _resolveFormState(
    WidgetRef ref,
    int? activityIdInt,
    int? opdIdInt,
  ) {
    if (activityIdInt == null) {
      return null;
    }

    if (isPublicReadOnly && opdIdInt != null) {
      return ref
          .watch(
            publicAssessmentDetailProvider((
              activityId: activityIdInt,
              opdId: opdIdInt,
            )),
          )
          .asData
          ?.value;
    }

    return ref
        .watch(assessmentFormControllerProvider(activityIdInt))
        .asData
        ?.value;
  }

  Map<String, List<IndicatorComparisonData>> _groupComparisonsByAspect(
    List<IndicatorComparisonData> comparisons,
  ) {
    final Map<String, List<IndicatorComparisonData>> groupedIndicators = {};
    for (final item in comparisons) {
      final String aspectName = item.namaAspek ?? 'Lainnya';
      groupedIndicators.putIfAbsent(aspectName, () => []).add(item);
    }
    return groupedIndicators;
  }

  Widget _buildIndicatorGroups(
    BuildContext context, {
    required List<IndicatorComparisonData> comparisons,
    required Map<String, List<IndicatorComparisonData>> groupedIndicators,
    required String? resolvedOpdId,
  }) {
    if (comparisons.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.pAll16,
        children: [
          AppEmptyState(
            icon: Icons.assignment_late_outlined,
            title: 'Tidak ada data.',
            message: isPublicReadOnly
                ? 'Belum ada indikator untuk domain publik ini.'
                : 'Belum ada indikator untuk domain ini.',
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pAll16,
      itemCount: groupedIndicators.length,
      itemBuilder: (context, groupIndex) {
        final aspectName = groupedIndicators.keys.elementAt(groupIndex);
        final items = groupedIndicators[aspectName]!;

        return _IndicatorAspectGroup(
          activityId: activityId,
          domainId: domainId,
          isSelfReview: isSelfReview,
          isPublicReadOnly: isPublicReadOnly,
          opdId: resolvedOpdId,
          aspectName: aspectName,
          items: items,
          comparisons: comparisons,
        );
      },
    );
  }

  Widget _buildDomainHeader(
    BuildContext context,
    AssessmentDomain domain,
    int total,
    int corrected,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: AppSpacing.pAll24,
      decoration: BoxDecoration(
        color: AppTheme.sogan,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.sogan,
            AppTheme.sogan.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DOMAIN PENILAIAN',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '$corrected / $total SELESAI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH16,
          Text(
            domain.namaDomain,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            'Konstribusi bobot domain sebesar ${domain.bobotDomain.toStringAsFixed(1)}%',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorAspectGroup extends StatelessWidget {
  const _IndicatorAspectGroup({
    required this.activityId,
    required this.domainId,
    required this.isSelfReview,
    required this.isPublicReadOnly,
    required this.opdId,
    required this.aspectName,
    required this.items,
    required this.comparisons,
  });

  final String activityId;
  final String domainId;
  final bool isSelfReview;
  final bool isPublicReadOnly;
  final String? opdId;
  final String aspectName;
  final List<IndicatorComparisonData> items;
  final List<IndicatorComparisonData> comparisons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Text(
            aspectName.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.6),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _IndicatorComparisonListItem(
              activityId: activityId,
              domainId: domainId,
              isSelfReview: isSelfReview,
              isPublicReadOnly: isPublicReadOnly,
              opdId: opdId,
              data: item,
              comparisons: comparisons,
              index: comparisons.indexOf(item),
            ),
          );
        }),
      ],
    );
  }
}

class _IndicatorComparisonListItem extends StatelessWidget {
  const _IndicatorComparisonListItem({
    required this.activityId,
    required this.domainId,
    required this.isSelfReview,
    required this.isPublicReadOnly,
    required this.opdId,
    required this.data,
    required this.comparisons,
    required this.index,
  });

  final String activityId;
  final String domainId;
  final bool isSelfReview;
  final bool isPublicReadOnly;
  final String? opdId;
  final IndicatorComparisonData data;
  final List<IndicatorComparisonData> comparisons;
  final int index;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool canNavigate = isSelfReview || opdId != null;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.indikator.namaIndikator,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  color: AppTheme.sogan,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            AppSpacing.gapW8,
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: canNavigate ? AppTheme.gold : AppTheme.neutral,
              size: 16,
            ),
          ],
        ),
        AppSpacing.gapH8,
        Text(
          'Bobot indikator ${data.indikator.bobotIndikator.toStringAsFixed(1)}%',
          style: textTheme.labelSmall?.copyWith(
            color: AppTheme.neutral,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapH16,
        CompactComparisonScoreCard(
          opdScore: data.opdScore,
          walidataScore: data.walidataScore,
          adminScore: data.adminScore,
        ),
      ],
    );

    final Widget card = EthnoCard(isFlat: true, child: content);

    return GestureDetector(
      onTap: () {
        if (!canNavigate) {
          showMissingReviewOpdContextFeedback(context);
          return;
        }

        context.push(
          isPublicReadOnly
              ? RouteConstants.buildPublicAssessmentIndicatorPath(
                  activityId: activityId,
                  opdId: opdId!,
                  domainId: domainId,
                  indicatorId: data.indikator.id.toString(),
                )
              : RouteConstants.buildAssessmentIndicatorPath(
                  activityId: activityId,
                  domainId: domainId,
                  indicatorId: data.indikator.id.toString(),
                  opdId: opdId,
                  isSelfReview: isSelfReview,
                ),
          extra: {
            'data': data,
            'comparisons': comparisons,
            'currentIndex': index,
          },
        );
      },
      child: card,
    );
  }
}
