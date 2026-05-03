import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_dashboard_repository.dart';
import '../../domain/admin_assessment_progress_query.dart';
import '../../domain/paged_admin_assessment_progress.dart';

class AdminDashboardController extends AsyncNotifier<AdminDashboardStats> {
  @override
  Future<AdminDashboardStats> build() async {
    return ref.read(adminDashboardRepositoryProvider).getStatistics();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(adminDashboardRepositoryProvider).getStatistics(),
    );
  }
}

final adminDashboardControllerProvider =
    AsyncNotifierProvider<AdminDashboardController, AdminDashboardStats>(() {
      return AdminDashboardController();
    });

final adminDashboardStatsProvider =
    AsyncNotifierProvider<AdminDashboardController, AdminDashboardStats>(() {
      return AdminDashboardController();
    });

class AdminDashboardProgressController
    extends AsyncNotifier<PagedAdminAssessmentProgress> {
  AdminAssessmentProgressQuery _query = const AdminAssessmentProgressQuery();

  @override
  Future<PagedAdminAssessmentProgress> build() async {
    return _fetch();
  }

  AdminAssessmentProgressQuery get query => _query;

  Future<void> setSearch(String search) async {
    _query = _query.copyWith(search: search, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> setSortBy(AdminAssessmentProgressSortBy sortBy) async {
    _query = _query.copyWith(sortBy: sortBy, page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> toggleSortDirection() async {
    _query = _query.copyWith(
      sortDirection: _query.sortDirection == SortDirection.asc
          ? SortDirection.desc
          : SortDirection.asc,
      page: 1,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> nextPage() async {
    final current = state.asData?.value;
    if (current != null && !current.hasNextPage) {
      return;
    }

    _query = _query.copyWith(page: _query.page + 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> previousPage() async {
    if (_query.page <= 1) {
      return;
    }

    _query = _query.copyWith(page: _query.page - 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refreshProgress() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<PagedAdminAssessmentProgress> _fetch() {
    return ref
        .read(adminDashboardRepositoryProvider)
        .getAssessmentProgressPage(_query);
  }
}

final adminDashboardProgressControllerProvider =
    AsyncNotifierProvider<
      AdminDashboardProgressController,
      PagedAdminAssessmentProgress
    >(() {
      return AdminDashboardProgressController();
    });
