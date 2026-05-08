import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

class MaturityScaleComparison extends StatelessWidget {
  const MaturityScaleComparison({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final level = index + 1;
            return Expanded(
              child: Column(
                children: [
                  Text(
                    'L$level',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutral,
                      fontSize: 9,
                    ),
                  ),
                  AppSpacing.gapH4,
                  _buildTrackSegment(level),
                ],
              ),
            );
          }),
        ),
        AppSpacing.gapH12,
        _buildLegend(context),
      ],
    );
  }

  Widget _buildTrackSegment(int level) {
    final List<Widget> markers = [];

    if (opdScore.round() == level) {
      markers.add(_buildMarker(AppTheme.sogan));
    }
    if (walidataScore.round() == level) {
      markers.add(_buildMarker(AppTheme.gold));
    }
    if (adminScore.round() == level) {
      markers.add(_buildMarker(AppTheme.success));
    }

    return Container(
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppTheme.neutralGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (markers.isNotEmpty)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: markers),
        ],
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        const _LegendItem(label: 'OPD', color: AppTheme.sogan),
        const _LegendItem(label: 'Walidata', color: AppTheme.gold),
        if (adminScore > 0)
          const _LegendItem(label: 'Admin', color: AppTheme.success),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.gapW4,
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.neutral,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
