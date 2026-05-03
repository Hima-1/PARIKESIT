import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/ethno_progress_bar.dart';

class AssessmentProgressCard extends StatelessWidget {
  const AssessmentProgressCard({
    super.key,
    required this.formulirName,
    required this.score,
    required this.date,
    required this.myProgress,
    required this.validatorProgress,
    required this.adminProgress,
    required this.unassignedIndicators,
  });

  final String formulirName;
  final double score;
  final String date;
  final double myProgress; // 0.0 to 1.0
  final double validatorProgress;
  final double adminProgress;
  final int unassignedIndicators;

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      isFlat: true,
      showBatikAccent: false,
      padding: AppSpacing.pAll20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Penilaian',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.sogan,
                      ),
                    ),
                    AppSpacing.gapH12,
                    Text(
                      formulirName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.sogan.withValues(alpha: 0.8),
                      ),
                    ),
                    AppSpacing.gapH4,
                    Text(
                      date,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: AppTheme.neutral),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.shellSurfaceSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.gold.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  score.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.sogan,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH24,
          EthnoProgressBar(
            label: 'Pengisian Saya',
            value: myProgress,
            color: AppTheme.sogan,
          ),
          AppSpacing.gapH16,
          EthnoProgressBar(
            label: 'Koreksi Walidata',
            value: validatorProgress,
            color: AppTheme.success,
          ),
          AppSpacing.gapH16,
          EthnoProgressBar(
            label: 'Evaluasi Admin',
            value: adminProgress,
            color: AppTheme.navy,
          ),
          AppSpacing.gapH20,
          Container(
            padding: AppSpacing.pAll12,
            decoration: AppTheme.warningContainerDecoration,
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppTheme.warning,
                ),
                AppSpacing.gapW8,
                Text(
                  '$unassignedIndicators indikator belum terisi',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
