import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class EthnoProgressBar extends StatelessWidget {
  const EthnoProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.showPercentage = true,
  });

  final String label;
  final double value; // 0.0 to 1.0
  final Color color;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.primary.withValues(alpha: 0.6),
              ),
            ),
            if (showPercentage)
              Text(
                '${(value * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
          ],
        ),
        AppSpacing.gapH8,
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
