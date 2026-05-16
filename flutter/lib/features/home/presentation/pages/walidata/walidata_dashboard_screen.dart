import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

import '../../../../../core/network/paginated_response.dart';
import '../../../../../core/router/route_constants.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/app_error_mapper.dart';
import '../../../../../core/widgets/app_empty_state.dart';
import '../../../../../core/widgets/app_error_state.dart';
import '../../../../../core/widgets/app_pagination_footer.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../assessment/domain/assessment_models.dart';
import '../../widgets/common/welcome_profile_card.dart';
import '../../widgets/walidata/walidata_activity_card.dart';

enum _FilterStatus { all, pending, process, done }

class WalidataDashboardScreen extends ConsumerStatefulWidget {
  const WalidataDashboardScreen({super.key});

  @override
  ConsumerState<WalidataDashboardScreen> createState() =>
      _WalidataDashboardScreenState();
}

class _WalidataDashboardScreenState
    extends ConsumerState<WalidataDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  _FilterStatus _filter = _FilterStatus.all;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(completedActivitiesProvider);
    final activitiesNotifier = ref.read(completedActivitiesProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      body: activitiesAsync.when(
        data: (activities) => _buildDataView(
          context: context,
          activities: activities,
          userName: user?.name ?? 'Walidata',
          email: user?.email ?? '-',
          phoneNumber: user?.nomorTelepon,
          onRefresh: activitiesNotifier.refreshCompletedActivities,
          onPrevious: activitiesNotifier.previousPage,
          onNext: activitiesNotifier.nextPage,
        ),
        loading: () => _buildScrollableState(
          userName: user?.name ?? 'Walidata',
          email: user?.email ?? '-',
          phoneNumber: user?.nomorTelepon,
          onRefresh: activitiesNotifier.refreshCompletedActivities,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        error: (err, stack) => _buildScrollableState(
          userName: user?.name ?? 'Walidata',
          email: user?.email ?? '-',
          phoneNumber: user?.nomorTelepon,
          onRefresh: activitiesNotifier.refreshCompletedActivities,
          child: AppErrorState(
            message: AppErrorMapper.toMessage(
              err,
              fallbackMessage: 'Gagal memuat data kegiatan. Silakan coba lagi.',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataView({
    required BuildContext context,
    required PaginatedResponse<AssessmentFormModel> activities,
    required String userName,
    required String email,
    required String? phoneNumber,
    required Future<void> Function() onRefresh,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
  }) {
    final filteredActivities = activities.items
        .where((activity) {
          final progress = activity.reviewProgress ?? _emptyReviewProgress;
          return switch (_filter) {
            _FilterStatus.all => true,
            _FilterStatus.pending => progress.correctedCount == 0,
            _FilterStatus.process =>
              progress.correctedCount > 0 && progress.percentage < 100,
            _FilterStatus.done => progress.percentage >= 100,
          };
        })
        .toList(growable: false);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshWithFeedback(onRefresh),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.pPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    userName: userName,
                    email: email,
                    phoneNumber: phoneNumber,
                  ),
                  AppSpacing.gapH16,
                  if (filteredActivities.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AppEmptyState(
                        icon: LucideIcons.searchX,
                        title: 'Data tidak ditemukan.',
                        message:
                            'Coba ubah filter untuk melihat data progress yang tersedia.',
                      ),
                    )
                  else
                    ...filteredActivities.map(
                      (activity) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildActivityCard(context, activity),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (filteredActivities.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.center,
              child: AppPaginationFooter(
                currentPage: activities.meta.currentPage,
                lastPage: activities.meta.lastPage,
                hasPreviousPage: activities.hasPreviousPage,
                hasNextPage: activities.hasNextPage,
                onPrevious: onPrevious,
                onNext: onNext,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScrollableState({
    required String userName,
    required String email,
    required String? phoneNumber,
    required Future<void> Function() onRefresh,
    required Widget child,
  }) {
    return RefreshIndicator(
      onRefresh: () => _refreshWithFeedback(onRefresh),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.pPage,
        children: [
          _buildHeader(
            userName: userName,
            email: email,
            phoneNumber: phoneNumber,
          ),
          AppSpacing.gapH16,
          child,
        ],
      ),
    );
  }

  Widget _buildHeader({
    required String userName,
    required String email,
    required String? phoneNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeProfileCard(
          userName: userName,
          email: email,
          phoneNumber: phoneNumber,
        ),
        AppSpacing.gapH24,
        const SectionHeader(title: 'Progress Penilaian'),
        AppSpacing.gapH12,
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _searchController,
          builder: (context, value, child) {
            return TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari progress penilaian',
                prefixIcon: const Icon(LucideIcons.search),
                border: const OutlineInputBorder(),
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(LucideIcons.x),
                      ),
              ),
              onChanged: _onSearchChanged,
            );
          },
        ),
        AppSpacing.gapH12,
        _buildFilterChips(),
      ],
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    AssessmentFormModel activity,
  ) {
    final progress = activity.reviewProgress ?? _emptyReviewProgress;

    return WalidataActivityCard(
      title: activity.title,
      date: activity.date,
      correctedCount: progress.correctedCount,
      totalCount: progress.totalIndicators,
      percentage: progress.percentage,
      finalCorrectionScore: progress.finalCorrectionScore,
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(
          RouteConstants.assessmentOpdSelection.replaceFirst(
            ':activityId',
            activity.id,
          ),
          extra: activity,
        );
      },
    );
  }

  Future<void> _refreshWithFeedback(Future<void> Function() onRefresh) async {
    await HapticFeedback.mediumImpact();
    await onRefresh();
  }

  static const ReviewProgressSummary _emptyReviewProgress =
      ReviewProgressSummary(
        totalIndicators: 0,
        correctedCount: 0,
        percentage: 0,
        pendingIndicatorPreview: <PendingIndicatorPreview>[],
      );

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(completedActivitiesProvider.notifier).setSearch(value.trim());
    });
    setState(() {});
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(_FilterStatus.all, 'SEMUA'),
          AppSpacing.gapW8,
          _buildChip(_FilterStatus.pending, 'MENUNGGU'),
          AppSpacing.gapW8,
          _buildChip(_FilterStatus.process, 'PROSES'),
          AppSpacing.gapW8,
          _buildChip(_FilterStatus.done, 'SELESAI'),
        ],
      ),
    );
  }

  Widget _buildChip(_FilterStatus status, String label) {
    final isSelected = _filter == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          HapticFeedback.selectionClick();
          setState(() => _filter = status);
        }
      },
      selectedColor: AppTheme.sogan.withValues(alpha: 0.15),
      side: BorderSide(
        color: isSelected
            ? AppTheme.sogan
            : AppTheme.neutral.withValues(alpha: 0.3),
      ),
      labelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: isSelected ? AppTheme.sogan : AppTheme.neutral,
      ),
    );
  }
}
