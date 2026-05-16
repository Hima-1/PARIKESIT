import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/router/route_constants.dart';
import '../../../core/widgets/app_pagination_footer.dart';
import '../../../core/widgets/section_header.dart';
import '../../home/presentation/widgets/common/welcome_profile_card.dart';
import 'controller/admin_dashboard_controller.dart';
import 'widgets/admin_assessment_progress_card.dart';
import 'widgets/admin_progress_empty_state.dart';
import 'widgets/admin_progress_filter_bar.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _handleRefresh(
    WidgetRef ref,
    AdminDashboardProgressController progressController,
  ) async {
    await Future.wait([
      ref.read(adminDashboardStatsProvider.notifier).refresh(),
      progressController.refreshProgress(),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final statsState = ref.watch(adminDashboardStatsProvider);
    final progressState = ref.watch(adminDashboardProgressControllerProvider);
    final progressController = ref.read(
      adminDashboardProgressControllerProvider.notifier,
    );
    final progressQuery = progressController.query;

    return statsState.when(
      data: (stats) => Scaffold(
        body: RefreshIndicator(
          onRefresh: () => _handleRefresh(ref, progressController),
          color: Theme.of(context).colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeProfileCard(
                  userName: user?.name ?? 'Admin',
                  email: user?.email ?? '-',
                  phoneNumber: user?.nomorTelepon,
                ),
                AppSpacing.gapH32,
                const SectionHeader(
                  title: 'Progress Penilaian',
                  padding: EdgeInsets.zero,
                ),
                AppSpacing.gapH16,
                AdminProgressFilterBar(
                  query: progressQuery,
                  onSearchChanged: progressController.setSearch,
                  onSortChanged: progressController.setSortBy,
                  onToggleSortDirection: progressController.toggleSortDirection,
                ),
                AppSpacing.gapH16,
                progressState.when(
                  data: (page) {
                    if (page.isEmpty) {
                      return AdminProgressEmptyState(
                        message: progressQuery.search.isNotEmpty
                            ? 'Tidak ada progress yang cocok dengan pencarian Anda.'
                            : 'Belum ada data penilaian aktif.',
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: page.items.length,
                          itemBuilder: (context, index) {
                            final progress = page.items[index];
                            return AdminAssessmentProgressCard(
                              progress: progress,
                              onTap: () => context.push(
                                RouteConstants.assessmentOpdSelection
                                    .replaceFirst(
                                      ':activityId',
                                      progress.id.toString(),
                                    ),
                              ),
                            );
                          },
                        ),
                        AppSpacing.gapH12,
                        Align(
                          alignment: Alignment.center,
                          child: AppPaginationFooter(
                            currentPage: page.currentPage,
                            lastPage: page.lastPage,
                            hasPreviousPage: page.hasPreviousPage,
                            hasNextPage: page.hasNextPage,
                            onPrevious: progressController.previousPage,
                            onNext: progressController.nextPage,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const AdminProgressEmptyState(
                    message: 'Gagal memuat progress penilaian.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
