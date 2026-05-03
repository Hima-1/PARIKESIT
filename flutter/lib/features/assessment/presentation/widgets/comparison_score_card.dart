import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';

import '../../../../../core/widgets/maturity_scale_comparison.dart';

class ComparisonScoreCard extends StatelessWidget {
  const ComparisonScoreCard({
    super.key,
    required this.nilaiAwal,
    required this.nilaiDiupdate,
    required this.nilaiEvaluasi,
    this.hasNilaiAwal = true,
    this.hasNilaiDiupdate = true,
    this.hasNilaiEvaluasi = true,
  });

  final double nilaiAwal;
  final double nilaiDiupdate;
  final double nilaiEvaluasi;
  final bool hasNilaiAwal;
  final bool hasNilaiDiupdate;
  final bool hasNilaiEvaluasi;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.sogan.withValues(alpha: 0.1)),
      ),
      color: AppTheme.shellSurface,
      child: Padding(
        padding: AppSpacing.pAll20,
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  _ScoreColumn(
                    label: 'OPD',
                    score: nilaiAwal,
                    color: AppTheme.sogan,
                    hasValue: hasNilaiAwal,
                  ),
                  const _VerticalDivider(),
                  _ScoreColumn(
                    label: 'Walidata',
                    score: nilaiDiupdate,
                    color: AppTheme.gold,
                    hasValue: hasNilaiDiupdate,
                  ),
                  const _VerticalDivider(),
                  _ScoreColumn(
                    label: 'Admin BPS',
                    score: nilaiEvaluasi,
                    color: AppTheme.success,
                    hasValue: hasNilaiEvaluasi,
                  ),
                ],
              ),
            ),
            AppSpacing.gapH24,
            const Divider(height: 1, thickness: 0.5),
            AppSpacing.gapH20,
            MaturityScaleComparison(
              opdScore: nilaiAwal,
              walidataScore: nilaiDiupdate,
              adminScore: nilaiEvaluasi,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.label,
    required this.score,
    required this.color,
    required this.hasValue,
  });

  final String label;
  final double score;
  final Color color;
  final bool hasValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: AppTheme.neutral,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.gapH12,
          Container(
            padding: AppSpacing.pH12V6,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Text(
              score.toStringAsFixed(2),
              style: textTheme.titleLarge?.copyWith(
                color: hasValue
                    ? color
                    : AppTheme.neutral.withValues(alpha: 0.55),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppTheme.sogan.withValues(alpha: 0.08),
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
