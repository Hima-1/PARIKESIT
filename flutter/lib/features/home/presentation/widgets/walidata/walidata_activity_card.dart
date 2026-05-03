import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';

import '../../../../../core/theme/app_theme.dart';

class WalidataActivityCard extends StatelessWidget {
  const WalidataActivityCard({
    super.key,
    required this.title,
    required this.date,
    required this.correctedCount,
    required this.totalCount,
    required this.percentage,
    required this.pendingIndicators,
    this.finalCorrectionScore,
    this.onTap,
  });

  final String title;
  final DateTime date;
  final int correctedCount;
  final int totalCount;
  final double percentage;
  final List<PendingIndicatorPreview> pendingIndicators;
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
                              Icons.calendar_today,
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
                    const Icon(Icons.chevron_right, color: AppTheme.neutral),
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
              if (pendingIndicators.isNotEmpty) ...[
                Text(
                  'Indikator Belum Dikoreksi',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.sogan,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.gapH8,
                Column(
                  children: [
                    for (final indicator in pendingIndicators.take(3)) ...[
                      _IndicatorPreviewTile(
                        name: indicator.name,
                        domain: indicator.domain,
                        aspect: indicator.aspect,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (pendingIndicators.length > 3)
                      _IndicatorPreviewTile(
                        name: '+${pendingIndicators.length - 3} lainnya',
                        domain: 'Prioritas lanjutan',
                        aspect: 'Ketuk kartu untuk detail',
                      ),
                  ],
                ),
                AppSpacing.gapH12,
                Text(
                  'Ketuk kartu untuk membuka daftar OPD dan detail indikator.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral.withValues(alpha: 0.72),
                    height: 1.35,
                  ),
                ),
                AppSpacing.gapH16,
              ],
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
                      isComplete
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
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

class _IndicatorPreviewTile extends StatelessWidget {
  const _IndicatorPreviewTile({
    required this.name,
    required this.domain,
    required this.aspect,
  });

  final String name;
  final String domain;
  final String aspect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$domain | $aspect',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.neutral.withValues(alpha: 0.75),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
