import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/ethno_donut_chart.dart';

class CorrectionStatsCard extends StatelessWidget {
  const CorrectionStatsCard({
    super.key,
    required this.progress,
    required this.totalIndicators,
    required this.correctedIndicators,
  });

  final double progress; // 0.0 to 1.0
  final int totalIndicators;
  final int correctedIndicators;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppTheme.sogan.withValues(alpha: 0.1)),
      ),
      color: AppTheme.shellSurface,
      child: Padding(
        padding: AppSpacing.pAll24,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progres Koreksi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.sogan,
                        ),
                      ),
                      AppSpacing.gapH8,
                      Text(
                        'Total indikator yang perlu dikoreksi dari semua OPD.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutral,
                        ),
                      ),
                      AppSpacing.gapH24,
                      _buildStatRow(
                        context,
                        'Sudah Dikoreksi',
                        correctedIndicators.toString(),
                        AppTheme.jatiGreen,
                      ),
                      AppSpacing.gapH12,
                      _buildStatRow(
                        context,
                        'Belum Dikoreksi',
                        (totalIndicators - correctedIndicators).toString(),
                        AppTheme.warning,
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapW24,
                Expanded(
                  flex: 2,
                  child: EthnoDonutChart(
                    verified: correctedIndicators.toDouble(),
                    inProgress: 0, // Logic for in-progress could be added later
                    notStarted: (totalIndicators - correctedIndicators)
                        .toDouble(),
                    centerText: '${(progress * 100).toInt()}%',
                    centerSubText: 'Selesai',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.gapW12,
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.sogan.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.sogan.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
