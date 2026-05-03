import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_patterns.dart';
import 'package:parikesit/core/widgets/status_banner.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:parikesit/features/assessment/presentation/helpers/indicator_review_resolver.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';
import 'package:parikesit/features/assessment/presentation/widgets/indicator_review_widgets.dart';

class IndicatorReadOnlyReviewScreen extends ConsumerWidget {
  const IndicatorReadOnlyReviewScreen({
    super.key,
    required this.activityId,
    required this.domainId,
    required this.indicatorId,
    this.isPublicReadOnly = false,
    this.opdId,
    this.data,
    this.indicatorComparisons = const <IndicatorComparisonData>[],
    this.currentIndex = 0,
  });

  final String activityId;
  final String domainId;
  final String indicatorId;
  final bool isPublicReadOnly;
  final String? opdId;
  final IndicatorComparisonData? data;
  final List<IndicatorComparisonData> indicatorComparisons;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? activityIdInt = int.tryParse(activityId);
    final AssessmentFormState? formState = activityIdInt == null
        ? null
        : isPublicReadOnly
        ? ref
              .watch(
                publicAssessmentDetailProvider((
                  activityId: activityIdInt,
                  opdId: int.tryParse(opdId ?? '') ?? 0,
                )),
              )
              .asData
              ?.value
        : ref
              .watch(assessmentFormControllerProvider(activityIdInt))
              .asData
              ?.value;
    final List<IndicatorComparisonData> resolvedComparisons =
        resolveIndicatorComparisonList(
          snapshots: indicatorComparisons.isNotEmpty
              ? indicatorComparisons
              : (data != null
                    ? <IndicatorComparisonData>[data!]
                    : const <IndicatorComparisonData>[]),
          formState: formState,
        );
    final IndicatorComparisonData? currentData = resolveIndicatorComparisonData(
      indicatorId: indicatorId,
      routeData: data,
      snapshots: resolvedComparisons,
      formState: formState,
    );

    if (currentData == null) {
      return Scaffold(
        backgroundColor: isPublicReadOnly
            ? AppTheme.merang
            : Colors.transparent,
        appBar: AppBar(
          title: Text(
            isPublicReadOnly ? 'Hasil Indikator OPD' : 'Tinjau Indikator',
          ),
        ),
        body: isPublicReadOnly
            ? const KawungBackground(
                opacity: 0.03,
                child: Center(child: Text('Data indikator tidak tersedia.')),
              )
            : const Center(child: Text('Data indikator tidak tersedia.')),
      );
    }

    final bool isFinal = currentData.adminScore > 0;
    final bool hasWalidataReview = !isFinal && currentData.walidataScore > 0;

    return Scaffold(
      backgroundColor: isPublicReadOnly ? AppTheme.merang : Colors.transparent,
      appBar: AppBar(
        title: Text(
          isPublicReadOnly ? 'Hasil Indikator OPD' : 'Tinjau Indikator',
        ),
        actions: [
          IndicatorReviewCounter(
            currentIndex: currentIndex,
            totalCount: resolvedComparisons.length,
          ),
        ],
      ),
      body: isPublicReadOnly
          ? KawungBackground(
              opacity: 0.03,
              child: SingleChildScrollView(
                padding: AppSpacing.pPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isFinal) ...[
                      const StatusBanner(
                        message:
                            'Penilaian ini telah dievaluasi oleh Admin BPS dan bersifat final.',
                        type: StatusBannerType.success,
                      ),
                      AppSpacing.gapH16,
                    ] else if (hasWalidataReview) ...[
                      const StatusBanner(
                        message:
                            'Penilaian ini sudah dikoreksi oleh Walidata. Detail koreksi dapat ditinjau pada bagian nilai dan catatan.',
                        type: StatusBannerType.info,
                      ),
                      AppSpacing.gapH16,
                    ],
                    const StatusBanner(
                      message:
                          'Mode publik read-only hanya menampilkan hasil penilaian yang sudah tersedia.',
                      type: StatusBannerType.info,
                    ),
                    AppSpacing.gapH16,
                    IndicatorReviewContent(
                      currentData: currentData,
                      isPublicReadOnly: true,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: AppSpacing.pPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isFinal) ...[
                    const StatusBanner(
                      message:
                          'Penilaian ini telah dievaluasi oleh Admin BPS dan bersifat final.',
                      type: StatusBannerType.success,
                    ),
                    AppSpacing.gapH16,
                  ] else if (hasWalidataReview) ...[
                    const StatusBanner(
                      message:
                          'Penilaian ini sudah dikoreksi oleh Walidata. Detail koreksi dapat ditinjau pada bagian nilai dan catatan.',
                      type: StatusBannerType.info,
                    ),
                    AppSpacing.gapH16,
                  ],
                  const StatusBanner(
                    message:
                        'Mode read-only hanya untuk meninjau hasil penilaian dan koreksi yang sudah tersedia.',
                    type: StatusBannerType.info,
                  ),
                  AppSpacing.gapH16,
                  IndicatorReviewContent(currentData: currentData),
                ],
              ),
            ),
      bottomNavigationBar: IndicatorReviewNavigationFooter(
        activityId: activityId,
        domainId: domainId,
        currentIndex: currentIndex,
        indicatorComparisons: resolvedComparisons,
        isSelfReview: true,
        isPublicReadOnly: isPublicReadOnly,
        opdId: opdId,
      ),
    );
  }
}
