import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';
import 'package:parikesit/features/home/presentation/pages/walidata/walidata_dashboard_screen.dart';

void main() {
  testWidgets('tapping progress card opens OPD selection instead of summary', (
    WidgetTester tester,
  ) async {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const WalidataDashboardScreen(),
        ),
        GoRoute(
          path: '/penilaian-selesai/:activityId/opds',
          builder: (BuildContext context, GoRouterState state) => Text(
            'opd-selection-${state.pathParameters['activityId']}',
            textDirection: TextDirection.ltr,
          ),
        ),
        GoRoute(
          path: '/penilaian-selesai/:activityId/summary',
          builder: (BuildContext context, GoRouterState state) => Text(
            'summary-${state.pathParameters['activityId']}',
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          completedActivitiesProvider.overrideWith(
            () => _StaticCompletedAssessmentListController(
              _paginated(<AssessmentFormModel>[_activityWithProgress()]),
            ),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Evaluasi SPBE 2026'));
    await tester.pumpAndSettle();

    expect(find.text('opd-selection-1'), findsOneWidget);
    expect(find.text('summary-1'), findsNothing);
  });

  testWidgets('shows search bar and filters progress cards by activity name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          completedActivitiesProvider.overrideWith(
            () => _StaticCompletedAssessmentListController(
              _paginated(<AssessmentFormModel>[
                _activityWithProgress(),
                AssessmentFormModel(
                  id: '2',
                  title: 'Audit Internal 2026',
                  date: DateTime(2026, 3, 15),
                  domains: const <DomainModel>[],
                  reviewProgress: const ReviewProgressSummary(
                    totalIndicators: 12,
                    correctedCount: 12,
                    percentage: 100,
                    pendingIndicatorPreview: <PendingIndicatorPreview>[],
                  ),
                ),
              ]),
            ),
          ),
        ],
        child: const MaterialApp(home: WalidataDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Evaluasi SPBE 2026'), findsOneWidget);
    expect(find.text('Audit Internal 2026'), findsOneWidget);
    expect(find.text('Riwayat'), findsNothing);

    await tester.enterText(find.byType(TextField), 'audit');
    // Allow debounce (400ms) plus rebuild settle.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('Evaluasi SPBE 2026'), findsNothing);
    expect(find.text('Audit Internal 2026'), findsOneWidget);
  });

  testWidgets('shows progress cards without inline indicator preview', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          completedActivitiesProvider.overrideWith(
            () => _StaticCompletedAssessmentListController(
              _paginated(<AssessmentFormModel>[_activityWithProgress()]),
            ),
          ),
        ],
        child: const MaterialApp(home: WalidataDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Progress Penilaian'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Evaluasi SPBE 2026'), findsOneWidget);
    expect(find.text('Koreksi Walidata'), findsOneWidget);
    expect(find.text('8/10 (80%)'), findsOneWidget);
    expect(find.text('Indikator Belum Dikoreksi'), findsNothing);
    expect(find.text('Indikator A'), findsNothing);
    expect(find.text('Riwayat'), findsNothing);

    final footerCenter = tester.getCenter(find.byType(AppPaginationFooter)).dx;
    expect(
      (footerCenter - tester.view.physicalSize.width / 2).abs(),
      lessThan(1),
    );
  });

  testWidgets('shows empty progress state without indicator preview copy', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          completedActivitiesProvider.overrideWith(
            () => _StaticCompletedAssessmentListController(
              _paginated(const <AssessmentFormModel>[]),
            ),
          ),
        ],
        child: const MaterialApp(home: WalidataDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Data tidak ditemukan.'), findsOneWidget);
    expect(find.text('Indikator Belum Dikoreksi'), findsNothing);
    expect(find.text('Riwayat'), findsNothing);
  });

  testWidgets('activities error state does not show retry button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          completedActivitiesProvider.overrideWith(
            _ThrowingCompletedAssessmentListController.new,
          ),
        ],
        child: const MaterialApp(home: WalidataDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Gagal memuat data kegiatan. Silakan coba lagi.'),
      findsOneWidget,
    );
    expect(find.text('Coba Lagi'), findsNothing);
  });
}

AssessmentFormModel _activityWithProgress() {
  return AssessmentFormModel(
    id: '1',
    title: 'Evaluasi SPBE 2026',
    date: DateTime(2026, 3, 14),
    domains: <DomainModel>[
      DomainModel(
        id: 'domain-1',
        name: 'Kebijakan',
        date: DateTime(2026, 3, 14),
        aspects: const <AspectModel>[],
        indicatorCount: 4,
      ),
    ],
    reviewProgress: const ReviewProgressSummary(
      totalIndicators: 10,
      correctedCount: 8,
      percentage: 80,
      finalCorrectionScore: 4.25,
      pendingIndicatorPreview: <PendingIndicatorPreview>[
        PendingIndicatorPreview(
          id: 10,
          name: 'Indikator A',
          domain: 'Kebijakan',
          aspect: 'Perencanaan',
          userId: 5,
          userName: 'Dinas Kominfo',
        ),
      ],
    ),
  );
}

PaginatedResponse<AssessmentFormModel> _paginated(
  List<AssessmentFormModel> data,
) {
  return PaginatedResponse<AssessmentFormModel>(
    data: data,
    meta: PaginationMeta(
      currentPage: 1,
      lastPage: 1,
      perPage: data.length,
      total: data.length,
      from: data.isEmpty ? null : 1,
      to: data.isEmpty ? null : data.length,
      path: '/penilaian-selesai',
    ),
    links: const PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );
}

class _StaticCompletedAssessmentListController
    extends CompletedAssessmentListController {
  _StaticCompletedAssessmentListController(this._value);

  final PaginatedResponse<AssessmentFormModel> _value;

  @override
  Future<PaginatedResponse<AssessmentFormModel>> build() async => _value;

  // Filter the in-memory fixture by title so the dashboard search exercise
  // does not depend on the API-backed setSearch path.
  @override
  Future<void> setSearch(String value) async {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      state = AsyncData(_value);
      return;
    }
    final filtered = _value.items
        .where((a) => a.title.toLowerCase().contains(query))
        .toList(growable: false);
    state = AsyncData(
      PaginatedResponse<AssessmentFormModel>(
        data: filtered,
        meta: _value.meta,
        links: _value.links,
      ),
    );
  }
}

class _ThrowingCompletedAssessmentListController
    extends CompletedAssessmentListController {
  @override
  Future<PaginatedResponse<AssessmentFormModel>> build() async {
    throw Exception('activities gagal dimuat');
  }
}
