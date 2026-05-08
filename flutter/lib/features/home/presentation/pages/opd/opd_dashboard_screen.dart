import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/auth/app_user.dart';
import '../../../../../core/network/paginated_response.dart';
import '../../../../../core/router/route_constants.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/app_error_mapper.dart';
import '../../../../../core/widgets/app_empty_state.dart';
import '../../../../../core/widgets/app_error_state.dart';
import '../../../../../core/widgets/app_pagination_footer.dart';
import '../../../../../core/widgets/ethno_button.dart';
import '../../../../../core/widgets/ethno_card.dart';
import '../../../../../core/widgets/ethno_donut_chart.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../home/presentation/widgets/common/welcome_profile_card.dart';
import '../../../../home/presentation/widgets/opd/assessment_progress_card.dart';
import '../../../domain/opd_dashboard_progress.dart';
import 'controller/opd_dashboard_controller.dart';

class OpdDashboardScreen extends ConsumerWidget {
  const OpdDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final opdProgressAsync = ref.watch(opdDashboardControllerProvider);
    final opdProgressNotifier = ref.read(
      opdDashboardControllerProvider.notifier,
    );

    return RefreshIndicator(
      onRefresh: () async {
        await HapticFeedback.mediumImpact();
        ref.invalidate(opdDashboardControllerProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.pPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeProfileCard(
              userName: user?.name ?? 'Pengguna OPD',
              email: user?.email ?? '-',
            ),
            AppSpacing.gapH24,
            opdProgressAsync.when(
              data: (progressPage) {
                final progressList = progressPage.items;
                if (progressList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: AppEmptyState(
                      icon: LucideIcons.clipboardList,
                      title: 'Belum ada data penilaian aktif.',
                      message:
                          'Progress penilaian aktif akan tampil di halaman ini saat tersedia.',
                    ),
                  );
                }

                final latest = _latestProgress(progressList);
                final needsFilling =
                    latest.progressPerIndikator.persentase < 100;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (needsFilling)
                      _DashboardReveal(
                        delay: const Duration(milliseconds: 80),
                        child: _buildQuickAction(context, latest),
                      ),
                    if (needsFilling) AppSpacing.gapH24,
                    _DashboardReveal(
                      delay: const Duration(milliseconds: 160),
                      child: _buildStatusDistribution(context, latest),
                    ),
                    AppSpacing.gapH32,
                    const SectionHeader(title: 'Daftar Kegiatan Penilaian'),
                    AppSpacing.gapH12,
                    ...progressList.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: AssessmentProgressCard(
                          formulirName: p.name,
                          score: (p.hasilPenilaianAkhir ?? 0).toDouble(),
                          date:
                              'Terakhir Update: ${DateFormat('dd MMMM yyyy', 'id_ID').format(p.date)}',
                          myProgress: (p.progressPerIndikator.persentase / 100)
                              .toDouble(),
                          validatorProgress:
                              (p.progressKoreksiWalidata.persentase / 100)
                                  .toDouble(),
                          adminProgress:
                              (p.progressEvaluasiAdmin.persentase / 100)
                                  .toDouble(),
                          unassignedIndicators:
                              p.progressPerIndikator.total -
                              (p.progressPerIndikator.terisi ?? 0),
                        ),
                      ),
                    ),
                    AppPaginationFooter(
                      currentPage: progressPage.meta.currentPage,
                      lastPage: progressPage.meta.lastPage,
                      hasPreviousPage: progressPage.hasPreviousPage,
                      hasNextPage: progressPage.hasNextPage,
                      onPrevious: opdProgressNotifier.previousPage,
                      onNext: opdProgressNotifier.nextPage,
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppTheme.sogan),
                  ),
                ),
              ),
              error: (err, stack) => AppErrorState(
                message: AppErrorMapper.toMessage(
                  err,
                  fallbackMessage: 'Gagal memuat dasbor. Silakan coba lagi.',
                ),
              ),
            ),
            AppSpacing.gapH48,
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    OpdDashboardProgress progress,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final int remaining =
        progress.progressPerIndikator.total -
        (progress.progressPerIndikator.terisi ?? 0);

    return EthnoCard(
      isFlat: true,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.sogan,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          gradient: LinearGradient(
            colors: [AppTheme.sogan, AppTheme.sogan.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LANJUTKAN PENGISIAN',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.gold,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    AppSpacing.gapH8,
                    Text(
                      'Ada $remaining indikator lagi di ${progress.name} yang perlu Anda lengkapi.',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapW16,
              EthnoButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.go(RouteConstants.assessmentMandiri);
                },
                style: EthnoButtonStyle.secondary,
                size: EthnoButtonSize.small,
                label: 'MULAI',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDistribution(
    BuildContext context,
    OpdDashboardProgress progress,
  ) {
    final total = progress.progressPerIndikator.total;
    if (total == 0) return const SizedBox.shrink();

    final terisi = progress.progressPerIndikator.terisi ?? 0;
    final inProgress = progress.progressKoreksiWalidata.sudahDikoreksi ?? 0;
    final verified = progress.progressEvaluasiAdmin.sudahDievaluasi ?? 0;
    final notStarted = total - terisi;

    final persentaseText =
        '${progress.progressPerIndikator.persentase.toInt()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Status Pengisian'),
        AppSpacing.gapH12,
        EthnoCard(
          isFlat: true,
          showBatikAccent: true,
          child: EthnoDonutChart(
            verified: verified.toDouble(),
            inProgress: inProgress.toDouble(),
            notStarted: notStarted.toDouble(),
            centerText: persentaseText,
            centerSubText: 'Terisi',
          ),
        ),
      ],
    );
  }

  OpdDashboardProgress _latestProgress(
    List<OpdDashboardProgress> progressList,
  ) {
    return progressList.reduce((
      OpdDashboardProgress current,
      OpdDashboardProgress candidate,
    ) {
      if (candidate.date.isAfter(current.date)) {
        return candidate;
      }
      return current;
    });
  }
}

class _DashboardReveal extends StatefulWidget {
  const _DashboardReveal({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_DashboardReveal> createState() => _DashboardRevealState();
}

class _DashboardRevealState extends State<_DashboardReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (!mounted) {
      return;
    }
    await _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
