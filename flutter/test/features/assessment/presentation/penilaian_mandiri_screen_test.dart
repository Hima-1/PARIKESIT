import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';
import 'package:parikesit/features/assessment/presentation/penilaian_mandiri_screen.dart';

void main() {
  group('PenilaianMandiriScreen', () {
    ProviderContainer createContainer(IAssessmentRepository repository) {
      return ProviderContainer(
        overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
      );
    }

    Future<void> pumpScreen(
      WidgetTester tester,
      ProviderContainer container,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: PenilaianMandiriScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows create and fill formulir toggle labels', (
      WidgetTester tester,
    ) async {
      final container = createContainer(_FakeAssessmentRepository());
      addTearDown(container.dispose);
      await pumpScreen(tester, container);

      expect(find.text('Buat Formulir'), findsOneWidget);
      expect(find.text('Isi Formulir'), findsOneWidget);
    });

    testWidgets('defaults to create formulir segment with add CTA', (
      WidgetTester tester,
    ) async {
      final container = createContainer(_FakeAssessmentRepository());
      addTearDown(container.dispose);
      await pumpScreen(tester, container);

      expect(find.byTooltip('Tambah formulir'), findsOneWidget);
      expect(find.text('Pilih formulir terlebih dahulu.'), findsNothing);
    });

    testWidgets('switches to isi formulir segment and shows assessment list', (
      WidgetTester tester,
    ) async {
      final container = createContainer(_FakeAssessmentRepository());
      addTearDown(container.dispose);
      await pumpScreen(tester, container);
      await tester.tap(find.text('Isi Formulir'));
      await tester.pumpAndSettle();

      expect(find.text('Tambah Formulir'), findsNothing);
      expect(find.text('MULAI MENILAI'), findsOneWidget);
      expect(find.text('Formulir OPD'), findsWidgets);
      expect(find.text('Halaman 1 dari 1'), findsOneWidget);
    });

    testWidgets(
      'shows formulir from assessment list controller state after add flow updates it',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assessmentRepositoryProvider.overrideWithValue(
                _EmptyAssessmentRepository(),
              ),
              assessmentListControllerProvider.overrideWith(
                () => _StaticAssessmentListController(<AssessmentFormModel>[
                  AssessmentFormModel(
                    id: '8',
                    title: 'Formulir Baru',
                    date: DateTime(2026, 3, 13),
                    domains: const <DomainModel>[],
                  ),
                ]),
              ),
            ],
            child: const MaterialApp(home: PenilaianMandiriScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Formulir Baru'), findsOneWidget);
      },
    );

    testWidgets('pull to refresh reloads create formulir list', (
      WidgetTester tester,
    ) async {
      final repository = _RefreshingAssessmentRepository();
      final container = createContainer(repository);
      addTearDown(container.dispose);
      await pumpScreen(tester, container);

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Formulir OPD'), findsWidgets);
      expect(find.text('Formulir OPD Terbaru'), findsNothing);

      final initialCalls = repository.activitiesCallCount;
      repository.useUpdatedActivities();
      container.invalidate(assessmentListControllerProvider);
      await container.read(assessmentListControllerProvider.future);
      await tester.pumpAndSettle();

      expect(repository.activitiesCallCount, greaterThan(initialCalls));
      expect(find.text('Formulir OPD Terbaru'), findsWidgets);
    });

    testWidgets(
      'pull to refresh reloads isi formulir list before a form is selected',
      (WidgetTester tester) async {
        final repository = _RefreshingAssessmentRepository();
        final container = createContainer(repository);
        addTearDown(container.dispose);
        await pumpScreen(tester, container);

        await tester.tap(find.text('Isi Formulir'));
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
        expect(find.text('Formulir OPD'), findsWidgets);
        expect(find.text('Formulir OPD Terbaru'), findsNothing);

        final initialCalls = repository.activitiesCallCount;
        repository.useUpdatedActivities();
        container.invalidate(assessmentListControllerProvider);
        await container.read(assessmentListControllerProvider.future);
        await tester.pumpAndSettle();

        expect(repository.activitiesCallCount, greaterThan(initialCalls));
        expect(find.text('Formulir OPD Terbaru'), findsWidgets);
      },
    );

    testWidgets(
      'pull to refresh reloads selected formulir detail without resetting local UI state',
      (WidgetTester tester) async {
        final repository = _RefreshingAssessmentRepository();
        final container = createContainer(repository);
        addTearDown(container.dispose);
        await pumpScreen(tester, container);

        await tester.tap(find.text('Isi Formulir'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Formulir OPD').first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Domain 1'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'indikator');
        await tester.pumpAndSettle();

        expect(find.text('Indikator 1'), findsOneWidget);
        expect(find.text('Indikator 1 Terbaru'), findsNothing);

        final initialMyPenilaiansCalls = repository.myPenilaiansCallCount;
        repository.useUpdatedFormDetail();
        container.invalidate(assessmentFormControllerProvider(1));
        await container.read(assessmentFormControllerProvider(1).future);
        await tester.pumpAndSettle();

        expect(
          repository.myPenilaiansCallCount,
          greaterThan(initialMyPenilaiansCalls),
        );
        expect(find.text('Indikator 1 Terbaru'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .controller
              .text,
          'indikator',
        );
      },
    );
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

class _FakeAssessmentRepository implements IAssessmentRepository {
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
  Future<AssessmentFormModel> getFormulir(int id) async => _sampleFormulir();

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[_sampleFormulir()];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: query.page,
      lastPage: 1,
      perPage: query.perPage,
      total: 1,
      from: 1,
      to: 1,
      path: '/penilaian-selesai',
    ),
    links: const PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (_sampleFormulir(), <int, Penilaian>{});

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
  ) async => (_sampleFormulir(), <int, Penilaian>{});

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': 4.0, 'walidata': null, 'admin': null};

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

  AssessmentFormModel _sampleFormulir() {
    return AssessmentFormModel(
      id: '1',
      title: 'Formulir OPD',
      date: DateTime(2026, 3, 13),
      domains: <DomainModel>[
        DomainModel(
          id: '10',
          name: 'Domain 1',
          date: DateTime(2026, 3, 13),
          aspects: <AspectModel>[
            const AspectModel(
              id: '20',
              name: 'Aspek 1',
              indicators: <IndicatorModel>[
                IndicatorModel(id: '30', name: 'Indikator 1'),
              ],
            ),
          ],
          indicatorCount: 1,
        ),
      ],
    );
  }
}

class _EmptyAssessmentRepository implements IAssessmentRepository {
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
  Future<AssessmentFormModel> getFormulir(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: query.page,
      lastPage: 1,
      perPage: query.perPage,
      total: 0,
      from: null,
      to: null,
      path: '/penilaian-selesai',
    ),
    links: const PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async {
    throw UnimplementedError();
  }

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
  ) async {
    throw UnimplementedError();
  }

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

class _RefreshingAssessmentRepository implements IAssessmentRepository {
  int activitiesCallCount = 0;
  int myPenilaiansCallCount = 0;
  bool _useUpdatedActivities = false;
  bool _useUpdatedFormDetail = false;

  void useUpdatedActivities() {
    _useUpdatedActivities = true;
  }

  void useUpdatedFormDetail() {
    _useUpdatedFormDetail = true;
  }

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
  Future<void> deleteActivity(int formulirId) async {}

  @override
  Future<AssessmentFormModel> getFormulir(int id) async => _buildForm();

  @override
  Future<List<AssessmentFormModel>> getActivities() async {
    activitiesCallCount++;
    return <AssessmentFormModel>[_buildForm()];
  }

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: query.page,
      lastPage: 1,
      perPage: query.perPage,
      total: 1,
      from: 1,
      to: 1,
      path: '/penilaian-selesai',
    ),
    links: const PaginationLinks(
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
  ) async => (_buildForm(), <int, Penilaian>{});

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async {
    myPenilaiansCallCount++;
    return (_buildForm(), <int, Penilaian>{});
  }

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
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<BuktiDukung> uploadBuktiDukung(int penilaianId, String filePath) {
    throw UnimplementedError();
  }

  AssessmentFormModel _buildForm() {
    return AssessmentFormModel(
      id: '1',
      title: _useUpdatedActivities ? 'Formulir OPD Terbaru' : 'Formulir OPD',
      date: DateTime(2026, 3, 13),
      domains: <DomainModel>[
        DomainModel(
          id: '10',
          name: 'Domain 1',
          date: DateTime(2026, 3, 13),
          aspects: <AspectModel>[
            AspectModel(
              id: '20',
              name: 'Aspek 1',
              indicators: <IndicatorModel>[
                IndicatorModel(
                  id: '30',
                  name: _useUpdatedFormDetail
                      ? 'Indikator 1 Terbaru'
                      : 'Indikator 1',
                ),
              ],
            ),
          ],
          indicatorCount: 1,
        ),
      ],
    );
  }
}
