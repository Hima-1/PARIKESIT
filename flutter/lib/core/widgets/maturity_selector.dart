import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

class MaturitySelector extends StatelessWidget {
  const MaturitySelector({
    super.key,
    required this.selectedScore,
    required this.onChanged,
    this.enabled = true,
    this.opdScore,
    this.walidataScore,
    this.adminScore,
  });

  final double selectedScore;
  final ValueChanged<double> onChanged;
  final bool enabled;

  // Optional markers for audit visibility
  final double? opdScore;
  final double? walidataScore;
  final double? adminScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final level = index + 1;
            final double scoreValue = level.toDouble();
            final isSelected = selectedScore.round() == level;

            return Expanded(
              child: GestureDetector(
                onTap: enabled ? () => onChanged(scoreValue) : null,
                child: Column(
                  children: [
                    Text(
                      'LEVEL $level',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected ? AppTheme.sogan : AppTheme.neutral,
                        fontSize: 9,
                      ),
                    ),
                    AppSpacing.gapH8,
                    _buildSelectionSegment(context, level, isSelected),
                    if (opdScore != null ||
                        walidataScore != null ||
                        adminScore != null)
                      _buildAuditMarkers(level),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSelectionSegment(
    BuildContext context,
    int level,
    bool isSelected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.sogan
            : (enabled
                  ? AppTheme.sogan.withValues(alpha: 0.05)
                  : AppTheme.neutralGrey),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: isSelected ? AppTheme.gold : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: isSelected
            ? const Icon(LucideIcons.checkCircle2, color: AppTheme.gold, size: 24)
            : Text(
                '$level',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: enabled
                      ? AppTheme.sogan.withValues(alpha: 0.4)
                      : AppTheme.neutral,
                ),
              ),
      ),
    );
  }

  Widget _buildAuditMarkers(int level) {
    final List<Widget> markers = [];

    if (opdScore?.round() == level) {
      markers.add(_buildMarker(AppTheme.sogan, 'OPD'));
    }
    if (walidataScore?.round() == level) {
      markers.add(_buildMarker(AppTheme.gold, 'W'));
    }
    if (adminScore?.round() == level) {
      markers.add(_buildMarker(AppTheme.success, 'A'));
    }

    if (markers.isEmpty) return const SizedBox(height: 16);

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: markers,
      ),
    );
  }

  Widget _buildMarker(Color color, String label) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Text(
          label[0],
          style: const TextStyle(
            fontSize: 7,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
