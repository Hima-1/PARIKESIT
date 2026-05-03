import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';

class CompactComparisonScoreCard extends StatelessWidget {
  const CompactComparisonScoreCard({
    super.key,
    required this.opdScore,
    required this.walidataScore,
    required this.adminScore,
  });

  final double opdScore;
  final double walidataScore;
  final double adminScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.pAll12,
      decoration: BoxDecoration(
        color: AppTheme.shellSurfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          _ScorePill(label: 'OPD', score: opdScore, color: AppTheme.sogan),
          AppSpacing.gapW8,
          _ScorePill(
            label: 'Walidata',
            score: walidataScore,
            color: AppTheme.gold,
          ),
          AppSpacing.gapW8,
          _ScorePill(
            label: 'Admin',
            score: adminScore,
            color: AppTheme.success,
          ),
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({
    required this.label,
    required this.score,
    required this.color,
  });

  final String label;
  final double score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.shellSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.neutral,
                  fontWeight: FontWeight.w800,
                  fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                ),
              ),
              AppSpacing.gapH4,
              Text(
                score.toStringAsFixed(2),
                style: textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
