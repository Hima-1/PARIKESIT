import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/ethno_progress_bar.dart';
import '../../domain/admin_assessment_progress.dart';

class AdminAssessmentProgressCard extends StatelessWidget {
  const AdminAssessmentProgressCard({
    super.key,
    required this.progress,
    this.onTap,
  });

  final AdminAssessmentProgress progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return EthnoCard(
      isFlat: true,
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progress.name,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.sogan,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            AppDateFormatter.fullDate(progress.date),
            style: textTheme.labelSmall?.copyWith(color: AppTheme.neutral),
          ),
          AppSpacing.gapH24,
          Text(
            'Statistik Pengisian',
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.sogan,
            ),
          ),
          AppSpacing.gapH16,
          EthnoProgressBar(
            label: 'Pengisian OPD',
            value: progress.opdTotalCount > 0
                ? (progress.opdFilledCount / progress.opdTotalCount)
                : 0.0,
            color: AppTheme.navy,
          ),
          AppSpacing.gapH16,
          EthnoProgressBar(
            label: 'Koreksi Walidata',
            value: progress.walidataTotalCount > 0
                ? (progress.walidataCorrectedCount /
                      progress.walidataTotalCount)
                : 0.0,
            color: AppTheme.sogan,
          ),
          AppSpacing.gapH16,
          Text(
            'Proses pengisian dan koreksi masih berlangsung',
            style: textTheme.labelSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppTheme.neutral.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
