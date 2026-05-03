import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/features/admin/data/admin_dashboard_repository.dart';
import 'package:parikesit/features/admin/domain/admin_assessment_progress.dart';
import 'package:parikesit/features/admin/domain/admin_assessment_progress_query.dart';
import 'package:parikesit/features/admin/domain/paged_admin_assessment_progress.dart';
import 'package:parikesit/features/admin/presentation/admin_dashboard_screen.dart';

void main() {
  testWidgets('renders search, sort, progress cards, and pagination controls', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeAdminDashboardRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(
            const AppUser(
              id: 1,
              name: 'Admin',
              email: 'admin@example.com',
              role: 'admin',
            ),
          ),
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Progress Penilaian'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Urutkan'), findsOneWidget);
    expect(find.text('Halaman 1 dari 3'), findsOneWidget);
    expect(find.text('Progress 1'), findsOneWidget);
  });

  testWidgets('pagination buttons drive page changes', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeAdminDashboardRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(
            const AppUser(
              id: 1,
              name: 'Admin',
              email: 'admin@example.com',
              role: 'admin',
            ),
          ),
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Halaman berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman 2 dari 3'), findsOneWidget);
    expect(find.text('Progress 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Halaman sebelumnya'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman 1 dari 3'), findsOneWidget);
  });

  testWidgets('search empty state is shown when no progress matches query', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeAdminDashboardRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(
            const AppUser(
              id: 1,
              name: 'Admin',
              email: 'admin@example.com',
              role: 'admin',
            ),
          ),
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'kosong');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(
      find.text('Tidak ada progress yang cocok dengan pencarian Anda.'),
      findsOneWidget,
    );
    expect(find.text('Coba lagi'), findsNothing);
    expect(find.text('Coba Lagi'), findsNothing);
  });

  testWidgets('pull to refresh reloads dashboard stats and progress', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeAdminDashboardRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(
            const AppUser(
              id: 1,
              name: 'Admin',
              email: 'admin@example.com',
              role: 'admin',
            ),
          ),
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();
    final initialStatsCalls = repository.statisticsCallCount;
    final initialProgressCalls = repository.progressCallCount;

    await tester.fling(
      find.byType(SingleChildScrollView),
      const Offset(0, 600),
      1000,
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(repository.statisticsCallCount, greaterThan(initialStatsCalls));
    expect(repository.progressCallCount, greaterThan(initialProgressCalls));
  });

  testWidgets('progress error state does not show retry button', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _ThrowingAdminProgressRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(
            const AppUser(
              id: 1,
              name: 'Admin',
              email: 'admin@example.com',
              role: 'admin',
            ),
          ),
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Gagal memuat progress penilaian.'), findsOneWidget);
    expect(find.text('Coba lagi'), findsNothing);
    expect(find.text('Coba Lagi'), findsNothing);
  });
}

class _FakeAdminDashboardRepository implements IAdminDashboardRepository {
  int statisticsCallCount = 0;
  int progressCallCount = 0;

  @override
  Future<AdminDashboardStats> getStatistics() async {
    statisticsCallCount++;
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
    progressCallCount++;
    if (query.search == 'kosong') {
      return PagedAdminAssessmentProgress(
        items: const <AdminAssessmentProgress>[],
        currentPage: 1,
        lastPage: 1,
        perPage: query.perPage,
        total: 0,
      );
    }

    return PagedAdminAssessmentProgress(
      items: <AdminAssessmentProgress>[
        AdminAssessmentProgress(
          id: query.page,
          name: 'Progress ${query.page}',
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
      total: 3,
    );
  }
}

class _ThrowingAdminProgressRepository extends _FakeAdminDashboardRepository {
  @override
  Future<PagedAdminAssessmentProgress> getAssessmentProgressPage(
    AdminAssessmentProgressQuery query,
  ) async {
    progressCallCount++;
    throw Exception('progress gagal dimuat');
  }
}
