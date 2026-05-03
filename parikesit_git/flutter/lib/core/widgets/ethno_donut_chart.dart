import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

class EthnoDonutChart extends StatelessWidget {
  const EthnoDonutChart({
    super.key,
    required this.verified,
    required this.inProgress,
    required this.notStarted,
    this.centerText,
    this.centerSubText,
    this.radius = 12,
    this.centerSpaceRadius = 50,
  });

  final double verified;
  final double inProgress;
  final double notStarted;
  final String? centerText;
  final String? centerSubText;
  final double radius;
  final double centerSpaceRadius;

  @override
  Widget build(BuildContext context) {
    final total = verified + inProgress + notStarted;
    if (total == 0) return const Center(child: Text('No data'));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: centerSpaceRadius,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      color: AppTheme.success,
                      value: verified,
                      title: '',
                      radius: radius,
                    ),
                    PieChartSectionData(
                      color: AppTheme.warning,
                      value: inProgress,
                      title: '',
                      radius: radius,
                    ),
                    PieChartSectionData(
                      color: AppTheme.neutral,
                      value: notStarted,
                      title: '',
                      radius: radius,
                    ),
                  ],
                ),
              ),
              if (centerText != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      centerText!,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.sogan,
                          ),
                    ),
                    if (centerSubText != null)
                      Text(
                        centerSubText!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        AppSpacing.gapH24,
        _buildLegend(context),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _LegendItem(color: AppTheme.success, label: 'Selesai'),
        _LegendItem(color: AppTheme.warning, label: 'Proses'),
        _LegendItem(color: AppTheme.neutral, label: 'Belum'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

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
        AppSpacing.gapW8,
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.neutral,
          ),
        ),
      ],
    );
  }
}
