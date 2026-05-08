import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/ethno_progress_bar.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';

class KegiatanPenilaianScreen extends ConsumerWidget {
  const KegiatanPenilaianScreen({super.key, required this.formulirId});

  final int formulirId;

  Future<void> _handleRefresh(WidgetRef ref) async {
    final future = ref.refresh(
      assessmentFormControllerProvider(formulirId).future,
    );
    await future;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (formulirId <= 0) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Isi Penilaian')),
        body: const Center(child: Text('Data formulir tidak valid.')),
      );
    }

    final activitiesAsync = ref.watch(
      assessmentFormControllerProvider(formulirId),
    );
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Isi Penilaian')),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: activitiesAsync.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 240),
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppTheme.sogan),
                ),
              ),
            ],
          ),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.pAll16,
            children: [
              const SizedBox(height: 200),
              Center(
                child: Text(
                  'Gagal memuat: $error',
                  style: textTheme.bodyMedium?.copyWith(color: AppTheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          data: (state) {
            final domains = state.formulir?.domains ?? [];

            if (domains.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppSpacing.pAll16,
                children: const [
                  AppEmptyState(
                    icon: LucideIcons.clipboardX,
                    title: 'Belum ada domain tersedia.',
                    message:
                        'Domain penilaian akan muncul di halaman ini setelah formulir dilengkapi.',
                  ),
                ],
              );
            }

            final int totalIndicators = domains.fold(
              0,
              (sum, domain) => sum + domain.indicatorCount,
            );
            final int filledIndicators = state.draftsByIndikatorId.length;
            final double progress = totalIndicators > 0
                ? (filledIndicators / totalIndicators)
                : 0.0;

            return Column(
              children: [
                if (totalIndicators > 0)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.shellSurfaceSoft,
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.sogan.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: EthnoProgressBar(
                      label: 'PENGISIAN MANDIRI',
                      value: progress,
                      color: progress == 1.0
                          ? AppTheme.success
                          : AppTheme.sogan,
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.pAll16,
                    itemCount: domains.length,
                    separatorBuilder: (context, index) => AppSpacing.gapH12,
                    itemBuilder: (context, index) {
                      final domain = domains[index];

                      return EthnoCard(
                        isFlat: true,
                        padding: EdgeInsets.zero,
                        child: ExpansionTile(
                          key: PageStorageKey('domain_${domain.id}'),
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          leading: Container(
                            padding: AppSpacing.pAll8,
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.layers,
                              color: AppTheme.gold,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            domain.name,
                            style: textTheme.titleSmall?.copyWith(
                              color: AppTheme.sogan,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            '${domain.aspects.length} ASPEK • ${domain.indicatorCount} INDIKATOR',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppTheme.neutral,
                              fontWeight: FontWeight.w700,
                              fontSize: EthnoTextTheme.of(
                                context,
                              ).labelTiny.fontSize,
                              letterSpacing: 0.5,
                            ),
                          ),
                          children: [
                            if (domain.aspects.isEmpty)
                              Padding(
                                padding: AppSpacing.pAll16,
                                child: Text(
                                  'Tidak ada aspek di domain ini.',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppTheme.neutral,
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: domain.aspects.map((aspek) {
                                  final int aspectFilled = aspek.indicators
                                      .where(
                                        (ind) => state.draftsByIndikatorId
                                            .containsKey(
                                              int.tryParse(ind.id) ?? -1,
                                            ),
                                      )
                                      .length;

                                  return ExpansionTile(
                                    key: PageStorageKey('aspek_${aspek.id}'),
                                    title: Text(
                                      aspek.name,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.sogan,
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            (aspectFilled ==
                                                        aspek.indicators.length
                                                    ? AppTheme.success
                                                    : AppTheme.neutral)
                                                .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$aspectFilled/${aspek.indicators.length}',
                                        style: textTheme.labelSmall?.copyWith(
                                          color:
                                              aspectFilled ==
                                                  aspek.indicators.length
                                              ? AppTheme.success
                                              : AppTheme.neutral,
                                          fontWeight: FontWeight.w900,
                                          fontSize:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.fontSize ??
                                              10,
                                        ),
                                      ),
                                    ),
                                    children: aspek.indicators.map((indicator) {
                                      final bool isFilled = state
                                          .draftsByIndikatorId
                                          .containsKey(
                                            int.tryParse(indicator.id) ?? -1,
                                          );
                                      return ListTile(
                                        contentPadding: const EdgeInsets.only(
                                          left: 32,
                                          right: 16,
                                        ),
                                        title: Text(
                                          indicator.name,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: isFilled
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            color: AppTheme.sogan.withValues(
                                              alpha: isFilled ? 1.0 : 0.7,
                                            ),
                                          ),
                                        ),
                                        trailing: Icon(
                                          isFilled
                                              ? LucideIcons.checkCircle2
                                              : Icons
                                                    .radio_button_unchecked_rounded,
                                          size: 18,
                                          color: isFilled
                                              ? AppTheme.success
                                              : AppTheme.neutral.withValues(
                                                  alpha: 0.3,
                                                ),
                                        ),
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          context.push(
                                            Uri(
                                              path:
                                                  '${RouteConstants.assessmentKegiatan}/indicator/${indicator.id}',
                                              queryParameters: {
                                                'formulirId': formulirId
                                                    .toString(),
                                                'nama': indicator.name,
                                              },
                                            ).toString(),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
