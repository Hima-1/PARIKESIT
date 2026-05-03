import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/admin/data/admin_dashboard_repository.dart';
import 'package:parikesit/features/admin/domain/admin_assessment_progress.dart';
import 'package:parikesit/features/admin/domain/admin_assessment_progress_query.dart';
import 'package:parikesit/features/admin/domain/paged_admin_assessment_progress.dart';
import 'package:parikesit/features/admin/presentation/controller/admin_dashboard_controller.dart';

void main() {
  test('loads stats and paged progress independently', () async {
    final repository = _FakeAdminDashboardRepository();
    final container = ProviderContainer(
      overrides: [
        adminDashboardRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final stats = await container.read(adminDashboardStatsProvider.future);
    final page = await container.read(
      adminDashboardProgressControllerProvider.future,
    );

    expect(stats.totalKegiatan, 4);
    expect(page.items, hasLength(1));
    expect(repository.statisticsCallCount, 1);
    expect(repository.progressQueries.single.page, 1);
  });

  test(
    'changing search resets page to first page and refetches progress',
    () async {
      final repository = _FakeAdminDashboardRepository();
      final container = ProviderContainer(
        overrides: [
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(adminDashboardProgressControllerProvider.future);
      final notifier = container.read(
        adminDashboardProgressControllerProvider.notifier,
      );

      await notifier.nextPage();
      await notifier.setSearch('dinas');

      final page = await container.read(
        adminDashboardProgressControllerProvider.future,
      );

      expect(page.currentPage, 1);
      expect(repository.progressQueries.last.search, 'dinas');
      expect(repository.progressQueries.last.page, 1);
    },
  );

  test('changing sort refetches with updated query', () async {
    final repository = _FakeAdminDashboardRepository();
    final container = ProviderContainer(
      overrides: [
        adminDashboardRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(adminDashboardProgressControllerProvider.future);
    final notifier = container.read(
      adminDashboardProgressControllerProvider.notifier,
    );

    await notifier.setSortBy(AdminAssessmentProgressSortBy.name);
    await notifier.toggleSortDirection();

    expect(
      repository.progressQueries[1].sortBy,
      AdminAssessmentProgressSortBy.name,
    );
    expect(repository.progressQueries[2].sortDirection, SortDirection.asc);
  });
}

class _FakeAdminDashboardRepository implements IAdminDashboardRepository {
  int statisticsCallCount = 0;
  final List<AdminAssessmentProgressQuery> progressQueries =
      <AdminAssessmentProgressQuery>[];

  @override
  Future<AdminDashboardStats> getStatistics() async {
    statisticsCallCount += 1;
    return AdminDashboardStats(
      totalOpd: 10,
      totalKegiatan: 4,
      averageScore: 87.5,
      progressDistribution: const <String, double>{},
      assessmentProgress: const <AdminAssessmentProgress>[],
    );
  }

  @override
  Future<PagedAdminAssessmentProgress> getAssessmentProgressPage(
    AdminAssessmentProgressQuery query,
  ) async {
    progressQueries.add(query);

    return PagedAdminAssessmentProgress(
      items: <AdminAssessmentProgress>[
        AdminAssessmentProgress(
          id: query.page,
          name: query.search.isEmpty
              ? 'Progress ${query.page}'
              : 'Hasil ${query.search}',
          date: DateTime(2026, 3, 14),
          opdFilledCount: 2,
          opdTotalCount: 4,
          walidataCorrectedCount: 1,
          walidataTotalCount: 4,
        ),
      ],
      currentPage: query.page,
      lastPage: 3,
      perPage: query.perPage,
      total: 12,
    );
  }
}
