import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/penilaian_selesai_screen.dart';

void main() {
  group('PenilaianSelesaiScreen', () {
    testWidgets('shows filter controls and admin-specific queue copy', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(
              _CompletedAssessmentRepository(),
            ),
            userRoleProvider.overrideWithValue(UserRole.admin),
          ],
          child: const MaterialApp(home: PenilaianSelesaiScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Antrian Evaluasi Final'), findsWidgets);
      expect(
        find.byKey(const Key('completed-assessment-search')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('completed-assessment-sort-field')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('completed-assessment-toggle-sort-direction')),
        findsOneWidget,
      );
      expect(find.text('Mulai evaluasi'), findsWidgets);
      expect(find.text('Skor admin: 3.42'), findsWidgets);
      expect(find.text('Perlu tindak lanjut'), findsWidgets);
      expect(find.text('Halaman 1 dari 2'), findsOneWidget);
    });

    testWidgets('shows walidata-specific copy for completed review queue', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(
              _CompletedAssessmentRepository(),
            ),
            userRoleProvider.overrideWithValue(UserRole.walidata),
          ],
          child: const MaterialApp(home: PenilaianSelesaiScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Antrian Koreksi'), findsWidgets);
      expect(find.text('Lanjutkan koreksi'), findsWidgets);
      expect(find.text('12 OPD terlibat'), findsWidgets);
      expect(find.text('12 Mar 2026'), findsWidgets);
      expect(find.text('1 domain penilaian'), findsWidgets);
      expect(find.text('1 domain'), findsNothing);
      expect(find.text('Perlu tindak lanjut'), findsNothing);
      expect(find.text('Skor walidata: 3.42'), findsNothing);
      expect(
        find.text('Tinjau skor OPD dan lanjutkan koreksi indikator.'),
        findsNothing,
      );
    });

    testWidgets(
      'hides score badge when completed activity has no summary score',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assessmentRepositoryProvider.overrideWithValue(
                _CompletedAssessmentRepository(withScores: false),
              ),
              userRoleProvider.overrideWithValue(UserRole.admin),
            ],
            child: const MaterialApp(home: PenilaianSelesaiScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Formulir Selesai'), findsWidgets);
        expect(find.text('3.42'), findsNothing);
        expect(find.text('-'), findsNothing);
        expect(find.textContaining('Skor admin:'), findsNothing);
      },
    );

    testWidgets('shows opd-specific compact copy focused on final date', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(
              _CompletedAssessmentRepository(),
            ),
            userRoleProvider.overrideWithValue(UserRole.opd),
          ],
          child: const MaterialApp(home: PenilaianSelesaiScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Penilaian Selesai'), findsWidgets);
      expect(find.text('HASIL FORMULIR'), findsNothing);
      expect(
        find.text(
          'Pantau hasil akhir formulir Anda yang sudah selesai diproses.',
        ),
        findsNothing,
      );
      expect(find.text('Hasil final tersedia'), findsNothing);
      expect(find.textContaining('Mar 2026'), findsWidgets);
      expect(find.text('Lihat hasil akhir'), findsWidgets);
      expect(find.text('Skor akhir: 3.42'), findsWidgets);
    });

    testWidgets(
      'search resets to first page and sends updated query to repository',
      (WidgetTester tester) async {
        final repository = _CompletedAssessmentRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assessmentRepositoryProvider.overrideWithValue(repository),
              userRoleProvider.overrideWithValue(UserRole.opd),
            ],
            child: const MaterialApp(home: PenilaianSelesaiScreen()),
          ),
        );

        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Halaman berikutnya'));
        await tester.pumpAndSettle();

        expect(find.text('Halaman 2 dari 2'), findsOneWidget);
        expect(repository.lastQuery.page, 2);

        await tester.enterText(
          find.byKey(const Key('completed-assessment-search')),
          'Alpha',
        );
        await tester.pump(const Duration(milliseconds: 450));
        await tester.pumpAndSettle();

        expect(repository.lastQuery.search, 'Alpha');
        expect(repository.lastQuery.page, 1);
        expect(find.text('Halaman 1 dari 1'), findsOneWidget);
        expect(find.text('Formulir Alpha'), findsOneWidget);
      },
    );

    testWidgets('sort controls refetch list with requested order', (
      WidgetTester tester,
    ) async {
      final repository = _CompletedAssessmentRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(repository),
            userRoleProvider.overrideWithValue(UserRole.admin),
          ],
          child: const MaterialApp(home: PenilaianSelesaiScreen()),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byType(DropdownButton<CompletedAssessmentSortField>),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nama formulir').last);
      await tester.pumpAndSettle();

      expect(repository.lastQuery.sort, CompletedAssessmentSortField.name);

      await tester.tap(
        find.byKey(const Key('completed-assessment-toggle-sort-direction')),
      );
      await tester.pumpAndSettle();

      expect(
        repository.lastQuery.direction,
        CompletedAssessmentSortDirection.asc,
      );
    });

    testWidgets('pagination buttons move between pages', (
      WidgetTester tester,
    ) async {
      final repository = _CompletedAssessmentRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(repository),
            userRoleProvider.overrideWithValue(UserRole.admin),
          ],
          child: const MaterialApp(home: PenilaianSelesaiScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Formulir Selesai'), findsWidgets);
      expect(find.text('Formulir Kedua'), findsNothing);

      await tester.tap(find.byTooltip('Halaman berikutnya'));
      await tester.pumpAndSettle();

      expect(repository.lastQuery.page, 2);
      expect(find.text('Formulir Kedua'), findsOneWidget);
      expect(find.text('Halaman 2 dari 2'), findsOneWidget);

      await tester.tap(find.byTooltip('Halaman sebelumnya'));
      await tester.pumpAndSettle();

      expect(repository.lastQuery.page, 1);
      expect(find.text('Formulir Selesai'), findsOneWidget);
      expect(find.text('Halaman 1 dari 2'), findsOneWidget);
    });

    testWidgets(
      'opd taps completed assessment card and opens self review route',
      (WidgetTester tester) async {
        final router = GoRouter(
          initialLocation: RouteConstants.assessmentSelesai,
          routes: [
            GoRoute(
              path: RouteConstants.assessmentSelesai,
              builder: (context, state) => const PenilaianSelesaiScreen(),
            ),
            GoRoute(
              path: RouteConstants.assessmentReview,
              builder: (context, state) =>
                  Text('SELF REVIEW ${state.pathParameters['activityId']}'),
            ),
          ],
        );
        addTearDown(router.dispose);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assessmentRepositoryProvider.overrideWithValue(
                _CompletedAssessmentRepository(),
              ),
              userRoleProvider.overrideWithValue(UserRole.opd),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('Lihat hasil akhir').first);
        await tester.pumpAndSettle();

        expect(find.text('SELF REVIEW 7'), findsOneWidget);
      },
    );
  });
}

class _CompletedAssessmentRepository implements AssessmentRepository {
  _CompletedAssessmentRepository({this.withScores = true});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  final bool withScores;
  CompletedAssessmentQuery lastQuery = const CompletedAssessmentQuery();
  int completedActivitiesCallCount = 0;

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
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[
        _buildForm('7', 'Formulir Selesai', DateTime(2026, 3, 1)),
      ];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async {
    completedActivitiesCallCount++;
    lastQuery = query;

    final allItems = <AssessmentFormModel>[
      _buildForm('7', 'Formulir Selesai', DateTime(2026, 3, 12)),
      _buildForm('10', 'Formulir Bravo', DateTime(2026, 3, 11)),
      _buildForm('11', 'Formulir Cakra', DateTime(2026, 3, 10)),
      _buildForm('12', 'Formulir Delta', DateTime(2026, 3, 9)),
      _buildForm('13', 'Formulir Elang', DateTime(2026, 3, 8)),
      _buildForm('14', 'Formulir Fajar', DateTime(2026, 3, 7)),
      _buildForm('15', 'Formulir Gama', DateTime(2026, 3, 6)),
      _buildForm('16', 'Formulir Harsa', DateTime(2026, 3, 5)),
      _buildForm('17', 'Formulir Intan', DateTime(2026, 3, 4)),
      _buildForm('19', 'Formulir Alpha', DateTime(2026, 3, 3)),
      _buildForm('8', 'Formulir Kedua', DateTime(2026, 3, 2)),
      _buildForm('20', 'Formulir Zeta', DateTime(2026, 3, 1)),
    ];

    Iterable<AssessmentFormModel> items = allItems;
    if (query.search.trim().isNotEmpty) {
      final keyword = query.search.trim().toLowerCase();
      items = items.where((item) => item.title.toLowerCase().contains(keyword));
    }

    final sortedItems = items.toList(growable: false)
      ..sort((a, b) {
        final comparison = switch (query.sort) {
          CompletedAssessmentSortField.createdAt => a.createdAt.compareTo(
            b.createdAt,
          ),
          CompletedAssessmentSortField.name => a.title.compareTo(b.title),
        };
        return query.direction == CompletedAssessmentSortDirection.asc
            ? comparison
            : -comparison;
      });

    final total = sortedItems.length;
    final lastPage = total == 0 ? 1 : ((total - 1) ~/ query.perPage) + 1;
    final safePage = query.page.clamp(1, lastPage);
    final start = total == 0 ? 0 : (safePage - 1) * query.perPage;
    final end = total == 0
        ? 0
        : (start + query.perPage > total ? total : start + query.perPage);
    final pageItems = sortedItems.sublist(start, end);

    return PaginatedResponse<AssessmentFormModel>(
      data: pageItems,
      meta: PaginationMeta(
        currentPage: safePage,
        lastPage: lastPage,
        perPage: query.perPage,
        total: total,
        from: total == 0 ? null : start + 1,
        to: total == 0 ? null : end,
        path: '/penilaian-selesai',
      ),
      links: const PaginationLinks(
        first: '/penilaian-selesai?page=1',
        last: '/penilaian-selesai?page=1',
        prev: null,
        next: null,
      ),
    );
  }

  AssessmentFormModel _buildForm(String id, String title, DateTime date) {
    return AssessmentFormModel(
      id: id,
      title: title,
      date: date,
      opdCount: 12,
      domains: <DomainModel>[
        DomainModel(
          id: '1',
          name: 'Domain Statistik',
          date: date,
          aspects: const <AspectModel>[],
          indicatorCount: 0,
        ),
      ],
      scores: withScores ? const RoleScore(admin: 3.42) : null,
    );
  }

  @override
  Future<AssessmentFormModel> getFormulir(int id) async =>
      throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => getCompletedActivities(query: query);

  @override
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async =>
      getOpdsForActivity(activityId);

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => throw UnimplementedError();

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
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitAdminEvaluation(Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitWalidataCorrection(Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async => throw UnimplementedError();
}
