import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/activity_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/widgets/bps_data_table.dart';

void main() {
  test(
    'buildIndicatorComparisonsForDomain uses penilaian payload as audit source of truth',
    () {
      final DomainModel domain = DomainModel(
        id: '10',
        name: 'Kelembagaan',
        date: DateTime(2026, 3, 14),
        indicatorCount: 1,
        aspects: <AspectModel>[
          const AspectModel(
            id: '20',
            name: 'Aspek A',
            indicators: <IndicatorModel>[
              IndicatorModel(
                id: '30',
                name: 'Indikator Audit',
                scores: RoleScore(opd: 1, walidata: 0, admin: 0),
              ),
            ],
          ),
        ],
      );

      final Map<int, Penilaian> assessments = <int, Penilaian>{
        30: const Penilaian(
          id: 99,
          formulirId: 7,
          indikatorId: 30,
          nilai: 2,
          catatan: 'Catatan OPD',
          nilaiDiupdate: 4,
          catatanKoreksi: 'Catatan Walidata',
          nilaiKoreksi: 5,
          evaluasi: 'Final Admin',
        ),
      };

      final comparisons = buildIndicatorComparisonsForDomain(
        domain,
        assessments,
      );

      expect(comparisons, hasLength(1));
      expect(comparisons.single.opdScore, 2);
      expect(comparisons.single.walidataScore, 4);
      expect(comparisons.single.adminScore, 5);
      expect(
        comparisons.single.evaluationNotes.map((note) => note.note).toList(),
        <String>['Catatan OPD', 'Catatan Walidata', 'Final Admin'],
      );
    },
  );

  test(
    'resolveDomainSummaryScore prefers explicit live summary over stale domain snapshot',
    () {
      final DomainModel domain = DomainModel(
        id: '10',
        name: 'Kelembagaan',
        date: DateTime(2026, 3, 14),
        indicatorCount: 1,
        aspects: const <AspectModel>[],
        scores: const RoleScore(opd: 1, walidata: 2, admin: 3),
      );

      final double? liveValue = resolveDomainSummaryScore(
        domain: domain,
        liveScoresByDomainId: const <String, RoleScore>{
          '10': RoleScore(opd: 2.5, walidata: 4.0, admin: null),
        },
      );

      expect(liveValue, 4.0);
    },
  );

  test(
    'resolveDomainSummaryScore falls back to domain snapshot only when no live summary exists',
    () {
      final DomainModel domain = DomainModel(
        id: '10',
        name: 'Kelembagaan',
        date: DateTime(2026, 3, 14),
        indicatorCount: 1,
        aspects: const <AspectModel>[],
        scores: const RoleScore(opd: 1.0, walidata: 2.0, admin: null),
      );

      final double? value = resolveDomainSummaryScore(
        domain: domain,
        liveScoresByDomainId: const <String, RoleScore>{},
      );

      expect(value, 2.0);
    },
  );

  testWidgets(
    'pull to refresh invalidates OPD stats and domain summaries for review recap',
    (tester) async {
      final repository = _RefreshingAssessmentRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(repository),
          ],
          child: PrimaryScrollController(
            controller: ScrollController(),
            child: MaterialApp(
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                scrollbars: false,
              ),
              home: const ActivityReviewScreen(activityId: '7', opdId: 11),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('3.25'), findsWidgets);
      expect(find.text('0.00'), findsNWidgets(2));
      expect(find.text('Perlu validasi akhir'), findsNothing);
      expect(find.text('Perbandingan skor stabil'), findsNothing);
      expect(find.text('DEVIASI BESAR'), findsNothing);
      expect(find.text('3.50'), findsNothing);
      expect(find.text('4.25'), findsNothing);

      repository.enableUpdatedScores();

      await tester.drag(find.byType(ListView).first, const Offset(0, 400));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('3.25'), findsWidgets);
      expect(find.text('3.50'), findsWidgets);
      expect(find.text('4.25'), findsWidgets);
    },
  );

  testWidgets(
    'BpsDataTable reserves space below rows for horizontal scrollbar',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BpsDataTable(
              columns: <String>['Domain', 'Skor Akhir'],
              rows: <List<Object>>[
                <Object>['Domain Statistik Nasional', '4.25'],
              ],
            ),
          ),
        ),
      );

      final hasScrollbarGutter = tester
          .widgetList<Padding>(find.byType(Padding))
          .any(
            (padding) => padding.padding == const EdgeInsets.only(bottom: 12),
          );

      expect(hasScrollbarGutter, isTrue);
      expect(find.text('Domain Statistik Nasional'), findsOneWidget);
    },
  );

  testWidgets(
    'domain summary keeps Domain Statistik Nasional row reachable in OPD recap',
    (tester) async {
      final repository = _RefreshingAssessmentRepository(
        includeNationalDomain: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(repository),
          ],
          child: PrimaryScrollController(
            controller: ScrollController(),
            child: MaterialApp(
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                scrollbars: false,
              ),
              home: const ActivityReviewScreen(activityId: '7', opdId: 11),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Domain Statistik Nasional'),
        300,
        scrollable: find
            .byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection == AxisDirection.down,
            )
            .first,
      );

      expect(find.text('Domain Statistik Nasional'), findsOneWidget);
      expect(find.text('4.25'), findsOneWidget);
    },
  );

  testWidgets('public activity review uses shared admin-style layout', (
    tester,
  ) async {
    final repository = _RefreshingAssessmentRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: ActivityReviewScreen(
            activityId: '7',
            opdId: 11,
            isPublicReadOnly: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('REKAP HASIL OPD'), findsOneWidget);
    expect(find.text('Ringkasan Nilai Domain'), findsOneWidget);
    expect(find.text('HASIL PENILAIAN PUBLIK'), findsNothing);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      AppTheme.merang,
    );
  });
}

class _RefreshingAssessmentRepository implements IAssessmentRepository {
  _RefreshingAssessmentRepository({this.includeNationalDomain = false});

  final bool includeNationalDomain;
  bool _useUpdatedScores = false;

  void enableUpdatedScores() {
    _useUpdatedScores = true;
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
      <AssessmentFormModel>[];

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

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<AssessmentFormModel> getFormulir(int id) async => _buildForm();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (
    _buildForm(),
    <int, Penilaian>{
      30: Penilaian(
        id: 1,
        formulirId: activityId,
        indikatorId: 30,
        nilai: 3.25,
        nilaiDiupdate: _useUpdatedScores ? 3.5 : null,
        nilaiKoreksi: _useUpdatedScores ? 4.25 : null,
        evaluasi: _useUpdatedScores ? 'Sudah dievaluasi' : null,
      ),
    },
  );

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => throw UnimplementedError();

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async {
    final scores = <String, RoleScore>{
      '10': RoleScore(
        opd: 3.25,
        walidata: _useUpdatedScores ? 3.5 : null,
        admin: _useUpdatedScores ? 4.25 : null,
      ),
    };

    if (includeNationalDomain) {
      scores.addAll(const <String, RoleScore>{
        '11': RoleScore(opd: 3.75),
        '12': RoleScore(admin: 4.25),
      });
    }

    return scores;
  }

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async =>
      <OpdModel>[];

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{
        'opd': 3.25,
        'walidata': _useUpdatedScores ? 3.5 : null,
        'admin': _useUpdatedScores ? 4.25 : null,
      };

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitAdminEvaluation(
    int assessmentId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitWalidataCorrection(
    int assessmentId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async => throw UnimplementedError();

  AssessmentFormModel _buildForm() {
    return AssessmentFormModel(
      id: '7',
      title: 'Formulir Review',
      date: DateTime(2026, 3, 16),
      domains: <DomainModel>[
        DomainModel(
          id: '10',
          name: 'Kelembagaan',
          date: DateTime(2026, 3, 16),
          indicatorCount: 1,
          aspects: <AspectModel>[
            const AspectModel(
              id: '20',
              name: 'Aspek A',
              indicators: <IndicatorModel>[
                IndicatorModel(id: '30', name: 'Indikator A'),
              ],
            ),
          ],
        ),
        if (includeNationalDomain)
          DomainModel(
            id: '11',
            name: 'Proses Bisnis Statistik',
            date: DateTime(2026, 3, 16),
            indicatorCount: 0,
            aspects: const <AspectModel>[],
          ),
        if (includeNationalDomain)
          DomainModel(
            id: '12',
            name: 'Domain Statistik Nasional',
            date: DateTime(2026, 3, 16),
            indicatorCount: 0,
            aspects: const <AspectModel>[],
          ),
      ],
    );
  }
}
