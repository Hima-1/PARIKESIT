import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_domain.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/activity_details_screen.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';
import 'package:parikesit/features/assessment/presentation/domain_correction_list_screen.dart';
import 'package:parikesit/features/assessment/presentation/kegiatan_penilaian_screen.dart';

void main() {
  testWidgets('loads detail formulir when list item does not include domains', (
    WidgetTester tester,
  ) async {
    final _ActivityDetailsRepository repository = _ActivityDetailsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(repository),
          assessmentListControllerProvider.overrideWith(
            () => _StaticAssessmentListController(<AssessmentFormModel>[
              AssessmentFormModel(
                id: '8',
                title: 'Formulir OPD',
                date: DateTime(2026, 3, 14),
                domains: const <DomainModel>[],
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: ActivityDetailsScreen(activityId: '8')),
      ),
    );

    await tester.pump();

    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(repository.getFormulirCallCount, 1);
    expect(find.text('Domain Terisi'), findsOneWidget);
    expect(find.text('Belum ada domain di formulir ini.'), findsNothing);
  });

  testWidgets(
    'shows empty state after detail load when formulir truly has no domains',
    (WidgetTester tester) async {
      final _EmptyDetailRepository repository = _EmptyDetailRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(repository),
            assessmentListControllerProvider.overrideWith(
              () => _StaticAssessmentListController(<AssessmentFormModel>[
                AssessmentFormModel(
                  id: '8',
                  title: 'Formulir OPD',
                  date: DateTime(2026, 3, 14),
                  domains: const <DomainModel>[],
                ),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: ActivityDetailsScreen(activityId: '8'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Belum ada domain di formulir ini.'), findsOneWidget);
      expect(
        find.text('Tambahkan domain untuk mulai menyusun formulir.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('navigates to add domain screen from tambah domain button', (
    WidgetTester tester,
  ) async {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return ProviderScope(
              overrides: [
                assessmentRepositoryProvider.overrideWithValue(
                  _ActivityDetailsRepository(),
                ),
                assessmentListControllerProvider.overrideWith(
                  () => _StaticAssessmentListController(<AssessmentFormModel>[
                    AssessmentFormModel(
                      id: '8',
                      title: 'Formulir OPD',
                      date: DateTime(2026, 3, 14),
                      domains: <DomainModel>[
                        DomainModel(
                          id: '10',
                          name: 'Domain Terisi',
                          date: DateTime(2026, 3, 14),
                          aspects: const <AspectModel>[],
                          indicatorCount: 0,
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
              child: const ActivityDetailsScreen(activityId: '8'),
            );
          },
        ),
        GoRoute(
          path: '/penilaian-kegiatan/:id/tambah-domain',
          builder: (BuildContext context, GoRouterState state) =>
              Text('Tambah Domain ${state.pathParameters['id']}'),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Domain'), findsOneWidget);

    await tester.tap(find.text('Tambah Domain'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Domain 8'), findsOneWidget);
  });

  testWidgets('KegiatanPenilaianScreen exposes pull to refresh', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(
            _ActivityDetailsRepository(),
          ),
        ],
        child: const MaterialApp(home: KegiatanPenilaianScreen(formulirId: 8)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('DomainCorrectionListScreen exposes pull to refresh', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(
            _ActivityDetailsRepository(),
          ),
        ],
        child: const MaterialApp(
          home: DomainCorrectionListScreen(
            activityId: '8',
            domainId: '10',
            isSelfReview: true,
            domain: AssessmentDomain(
              id: 10,
              namaDomain: 'Domain Terisi',
              bobotDomain: 100,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}

class _StaticAssessmentListController extends AssessmentListController {
  _StaticAssessmentListController(this._activities);

  final List<AssessmentFormModel> _activities;

  @override
  Future<PaginatedResponse<AssessmentFormModel>> build() async =>
      PaginatedResponse<AssessmentFormModel>(
        data: _activities,
        meta: PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: _activities.length,
          total: _activities.length,
          from: _activities.isEmpty ? null : 1,
          to: _activities.isEmpty ? null : _activities.length,
          path: '/formulir',
        ),
        links: const PaginationLinks(
          first: '/formulir?page=1',
          last: '/formulir?page=1',
        ),
      );
}

class _ActivityDetailsRepository implements IAssessmentRepository {
  int getFormulirCallCount = 0;

  @override
  Future<AssessmentFormModel> getFormulir(int id) async {
    getFormulirCallCount += 1;
    return AssessmentFormModel(
      id: '$id',
      title: 'Formulir OPD',
      date: DateTime(2026, 3, 14),
      domains: <DomainModel>[
        DomainModel(
          id: '10',
          name: 'Domain Terisi',
          date: DateTime(2026, 3, 14),
          aspects: const <AspectModel>[],
          indicatorCount: 0,
        ),
      ],
    );
  }

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[];

  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 0,
      from: null,
      to: null,
      path: '/formulir',
    ),
    links: const PaginationLinks(
      first: '/formulir?page=1',
      last: '/formulir?page=1',
    ),
  );

  @override
  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  }) async => activity;

  @override
  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {}

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteActivity(int formulirId) async {}

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => const PaginatedResponse<AssessmentFormModel>(
    data: <AssessmentFormModel>[],
    meta: PaginationMeta(
      currentPage: 1,
      lastPage: 1,
      perPage: 15,
      total: 0,
      from: null,
      to: null,
      path: '/penilaian-selesai',
    ),
    links: PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => getCompletedActivities(query: query);

  @override
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async =>
      getOpdsForActivity(activityId);

  Future<PaginatedResponse<OpdModel>> getOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async => PaginatedResponse<OpdModel>(
    data: await getOpdsForActivity(activityId),
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 0,
      from: null,
      to: null,
      path: '/penilaian-selesai/$activityId/opds',
    ),
    links: PaginationLinks(
      first: '/penilaian-selesai/$activityId/opds?page=1',
      last: '/penilaian-selesai/$activityId/opds?page=1',
    ),
  );

  Future<PaginatedResponse<OpdModel>> getPublicOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async => getOpdsForActivityPage(activityId, page: page, perPage: perPage);

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (await getFormulir(activityId), <int, Penilaian>{});

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => (await getFormulir(formulirId), <int, Penilaian>{});

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': null, 'walidata': null, 'admin': null};

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async => <String, RoleScore>{};

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async =>
      <OpdModel>[];

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Penilaian> submitAdminEvaluation(
    int assessmentId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Penilaian> submitWalidataCorrection(
    int assessmentId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<BuktiDukung> uploadBuktiDukung(int penilaianId, String filePath) {
    throw UnimplementedError();
  }
}

class _EmptyDetailRepository extends _ActivityDetailsRepository {
  @override
  Future<AssessmentFormModel> getFormulir(int id) async {
    getFormulirCallCount += 1;
    return AssessmentFormModel(
      id: '$id',
      title: 'Formulir OPD',
      date: DateTime(2026, 3, 14),
      domains: const <DomainModel>[],
    );
  }
}
