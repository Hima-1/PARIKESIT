import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart'
    show DomainModel, KegiatanModel;

class AssessmentFormCard extends StatelessWidget {
  const AssessmentFormCard({
    super.key,
    required this.assessment,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final KegiatanModel assessment;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatWithFallback(
      assessment.createdAt,
      primaryPattern: 'EEEE, d MMMM yyyy',
      fallbackPattern: 'EEEE, d MMMM yyyy',
    );

    return Card(
      elevation: 0,
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: const BorderSide(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assessment.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.sogan,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        LucideIcons.pencil,
                        color: AppTheme.success,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(
                        LucideIcons.trash2,
                        color: AppTheme.error,
                        size: 20,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: AppTheme.neutral,
                    ),
                    AppSpacing.gapW8,
                    Text(
                      formattedDate,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
                    ),
                  ],
                ),
                AppSpacing.gapH16,
                Align(
                  alignment: Alignment.centerRight,
                  child: EthnoButton(
                    onPressed: onTap,
                    style: EthnoButtonStyle.primary,
                    label: 'Lihat',
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

class DomainSummaryCard extends StatelessWidget {
  const DomainSummaryCard({super.key, required this.domain});

  final DomainModel domain;

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatWithFallback(
      domain.updatedAt,
      primaryPattern: 'd MMM yyyy, HH:mm',
      fallbackPattern: 'd MMM yyyy, HH:mm',
    );

    return Card(
      elevation: 0,
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: const BorderSide(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: AppSpacing.pAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              domain.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.sogan,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapH4,
            Text(
              formattedDate,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
            ),
            AppSpacing.gapH12,
            _BulletPoint(
              text: '${domain.aspects.length} Aspek',
              color: AppTheme.gold,
            ),
            AppSpacing.gapH4,
            _BulletPoint(
              text: '${domain.indicatorsCount} Indikator',
              color: AppTheme.gold,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatWithFallback(
  DateTime value, {
  required String primaryPattern,
  required String fallbackPattern,
}) {
  try {
    return DateFormat(primaryPattern, 'id_ID').format(value);
  } on Exception {
    return DateFormat(fallbackPattern).format(value);
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.gapW12,
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
