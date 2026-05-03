import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

class EthnoRadarChart extends StatelessWidget {
  const EthnoRadarChart({
    super.key,
    required this.currentScores,
    required this.targetScores,
    required this.labels,
  });

  final List<double> currentScores;
  final List<double> targetScores;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final bool hasEnoughData =
        currentScores.length >= 3 &&
        targetScores.length >= 3 &&
        labels.length >= 3;

    if (!hasEnoughData) {
      return Padding(
        padding: AppSpacing.pAll16,
        child: Column(
          children: [
            Text(
              'Data belum mencukupi untuk menampilkan grafik.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutral,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.gapH16,
            _buildLegend(context),
          ],
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              dataSets: [
                RadarDataSet(
                  fillColor: AppTheme.sogan.withValues(alpha: 0.2),
                  borderColor: AppTheme.sogan,
                  entryRadius: 3,
                  dataEntries: currentScores
                      .map((score) => RadarEntry(value: score))
                      .toList(),
                  borderWidth: 2,
                ),
                RadarDataSet(
                  fillColor: AppTheme.gold.withValues(alpha: 0.1),
                  borderColor: AppTheme.gold,
                  entryRadius: 0,
                  dataEntries: targetScores
                      .map((score) => RadarEntry(value: score))
                      .toList(),
                  borderWidth: 1,
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              radarBorderData: const BorderSide(
                color: AppTheme.neutral,
                width: 1,
              ),
              gridBorderData: const BorderSide(
                color: AppTheme.neutral,
                width: 1,
              ),
              tickBorderData: const BorderSide(
                color: AppTheme.neutral,
                width: 1,
              ),
              ticksTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.neutral,
                fontSize: 8,
              ),
              tickCount: 5,
              getTitle: (index, angle) {
                return RadarChartTitle(text: labels[index], angle: angle);
              },
              titlePositionPercentageOffset: 0.15,
              titleTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.sogan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AppSpacing.gapH16,
        _buildLegend(context),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppTheme.sogan, label: 'Capaian Saat Ini'),
        AppSpacing.gapW24,
        _LegendItem(color: AppTheme.gold, label: 'Target', isDashed: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.isDashed = false,
  });
  final Color color;
  final String label;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 2,
          decoration: BoxDecoration(color: color),
        ),
        AppSpacing.gapW8,
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.neutral,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
