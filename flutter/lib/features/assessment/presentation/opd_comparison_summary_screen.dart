import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';

import '../domain/comparison_summary_model.dart';

final comparisonSummaryProvider =
    FutureProvider.family<List<ComparisonSummaryModel>, String>((
      ref,
      activityId,
    ) async {
      final repository = ref.watch(assessmentRepositoryProvider);
      return repository.getComparisonSummary(activityId);
    });

class OpdComparisonSummaryScreen extends ConsumerWidget {
  const OpdComparisonSummaryScreen({
    super.key,
    required this.activityId,
    this.activity,
  });

  final String activityId;
  final AssessmentFormModel? activity;

  Future<void> _handleRefresh(WidgetRef ref) async {
    final future = ref.refresh(comparisonSummaryProvider(activityId).future);
    await future;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(comparisonSummaryProvider(activityId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ringkasan Perbandingan OPD'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              AppSpacing.gapH32,
              summaryState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (Object error, StackTrace stackTrace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    AppErrorMapper.toMessage(
                      error,
                      fallbackMessage:
                          'Gagal memuat ringkasan. Silakan coba lagi.',
                    ),
                  ),
                ),
                data: (List<ComparisonSummaryModel> summaries) {
                  if (summaries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AppEmptyState(
                        icon: LucideIcons.lineChart,
                        title: 'Belum ada ringkasan perbandingan OPD.',
                        message:
                            'Ringkasan perbandingan akan tampil di halaman ini setelah data tersedia.',
                      ),
                    );
                  }

                  return Column(
                    children: summaries
                        .map(
                          (summary) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SummaryCard(summary: summary),
                          ),
                        )
                        .toList(growable: false),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.sogan,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FORMULIR PENILAIAN',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.gold,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            activity?.title ?? 'Detail Kegiatan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            'Tahun Pelaksanaan: ${activity?.date.year ?? DateTime.now().year}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final ComparisonSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: AppSpacing.pAll16,
      decoration: BoxDecoration(
        color: AppTheme.shellSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.opdName,
            style: textTheme.bodyLarge?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapH12,
          Row(
            children: [
              Expanded(
                child: _ScoreTile(
                  label: 'Mandiri',
                  value: summary.skorMandiri,
                  color: AppTheme.sogan,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: _ScoreTile(
                  label: 'Walidata',
                  value: summary.skorWalidata,
                  color: AppTheme.gold,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: _ScoreTile(
                  label: 'Admin',
                  value: summary.skorBps,
                  color: AppTheme.jatiGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            value.toStringAsFixed(2),
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
