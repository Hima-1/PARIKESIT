import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../../../../../core/theme/app_theme.dart';

class WalidataActivityCard extends StatelessWidget {
  const WalidataActivityCard({
    super.key,
    required this.title,
    required this.date,
    required this.correctedCount,
    required this.totalCount,
    required this.percentage,
    this.finalCorrectionScore,
    this.onTap,
  });

  final String title;
  final DateTime date;
  final int correctedCount;
  final int totalCount;
  final double percentage;
  final double? finalCorrectionScore;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? (correctedCount / totalCount) : 0.0;
    final isComplete = percentage >= 100;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.sogan.withValues(alpha: 0.1)),
      ),
      color: AppTheme.shellSurface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.sogan,
                              ),
                        ),
                        AppSpacing.gapH4,
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.calendar,
                              size: 14,
                              color: AppTheme.neutral,
                            ),
                            AppSpacing.gapW8,
                            Text(
                              _formatDate(date),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.neutral),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (finalCorrectionScore != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.merang,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Nilai Akhir',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.sogan,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          AppSpacing.gapH2,
                          Text(
                            finalCorrectionScore!.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.sogan,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Icon(
                      LucideIcons.chevronRight,
                      color: AppTheme.neutral,
                    ),
                ],
              ),
              AppSpacing.gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Koreksi Walidata',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.sogan.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    '$correctedCount/$totalCount (${percentage.toStringAsFixed(0)}%)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.sogan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH12,
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: AppTheme.sogan.withValues(alpha: 0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete ? AppTheme.success : AppTheme.warning,
                  ),
                ),
              ),
              AppSpacing.gapH16,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: isComplete
                    ? AppTheme.successContainerDecoration
                    : AppTheme.neutralContainerDecoration,
                child: Row(
                  children: [
                    Icon(
                      isComplete ? LucideIcons.checkCircle2 : LucideIcons.info,
                      size: 16,
                      color: isComplete
                          ? AppTheme.success
                          : AppTheme.sogan.withValues(alpha: 0.6),
                    ),
                    AppSpacing.gapW8,
                    Text(
                      isComplete
                          ? 'Semua indikator sudah dikoreksi'
                          : 'Proses koreksi masih berlangsung',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isComplete
                            ? AppTheme.success
                            : AppTheme.sogan.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    try {
      return DateFormat('d MMMM yyyy', 'id_ID').format(value);
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(value);
    }
  }
}
